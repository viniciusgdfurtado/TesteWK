unit TesteWK.Controller.PedidoVendas;

interface
uses
  System.SysUtils,
  FireDAC.Stan.Param,
  Data.DB,
  TesteWK.Controller.Base,
  TesteWK.Model.PedidoVendas;

resourcestring
  msDeletaItensPedido = 'delete from pedidos_produtos where numero_pedido = :numero_pedido';
  msDeletaCabecalhoPedido = 'delete from pedidos where numero_pedido = :numero_pedido';
  msPedidoVendaByCodigo = 'SELECT numero_pedido, data_emissao, codigo_cliente, valor_total FROM pedidos where numero_pedido = :numero_pedido';
  msItensPedidoVendaByCodigo = 'SELECT id, numero_pedido, codigo_produto, descricao, quantidade, valor_unitario, valor_total '
                             + ' FROM pedidos_produtos '
                             + ' inner join produtos on produtos.codigo = pedidos_produtos.codigo_produto '
                             + ' where numero_pedido = :numero_pedido';
  msInsertCabecalhoPedido = 'INSERT INTO pedidos(data_emissao, codigo_cliente, valor_total) '
			                    + ' VALUES(:data_emissao, :codigo_cliente, :valor_total)';
  msGetLastID = 'SELECT LAST_INSERT_ID() AS numero_pedido';
  msInsertItensPedido = 'INSERT INTO pedidos_produtos(numero_pedido, codigo_produto, quantidade, valor_unitario, valor_total) '
                      +	' VALUES (:numero_pedido,:codigo_produto, :quantidade, :valor_unitario, :valor_total);';

  msFalhaAoRecuperarPedido = 'Ocorreu um erro ao recuperar o Pedido de Venda %s, por favor tente novamente.';
  msPedidoInexistente = 'Não encontramos o registro do Pedido de Venda %s, por favor tente novamente ou informe um novo código.';
  msNenhumPedidoNaBase = 'Não há registros de Pedido de Venda para exibição.';

type
  TPedidoVendaController = class(TControllerBase)
    function GravaPedidoVenda(APedidoVenda : TPedidoVenda) : Integer;
    function GetPedidoVendaByNumero(ACodigo : Integer) : TPedidoVenda;
    function CancelaPedidoVendaByNumero(ACodigo : Integer) : Boolean;
  end;

implementation

{ TControllerPedidoVenda }

function TPedidoVendaController.CancelaPedidoVendaByNumero(
  ACodigo: Integer): Boolean;
begin
  Result := False;
  ConnectionController.StartTransaction;
  try
    // Deleta Itens
    QueryController.Close;
    QueryController.SQL.Clear;
    QueryController.SQL.Add(msDeletaItensPedido);
    QueryController.ParamByName('numero_pedido').AsInteger := ACodigo;
    QueryController.ExecSQL;

    // Deleta Cabecalho
    QueryController.Close;
    QueryController.SQL.Clear;
    QueryController.SQL.Add(msDeletaCabecalhoPedido);
    QueryController.ParamByName('numero_pedido').AsInteger := ACodigo;
    QueryController.ExecSQL;

    ConnectionController.Commit;
    Result := True;
  except on E: Exception do
    ConnectionController.Rollback;
  end;
end;

function TPedidoVendaController.GetPedidoVendaByNumero(
  ACodigo: Integer): TPedidoVenda;
begin
  Result := nil;
  try
    QueryController.Close;
    QueryController.SQL.Clear;
    QueryController.SQL.Add(msPedidoVendaByCodigo);
    QueryController.ParamByName('numero_pedido').AsInteger := ACodigo;
    QueryController.Open;

    if QueryController.IsEmpty then
      raise Exception.Create(Format(msPedidoInexistente, [ACodigo.ToString]));

    Result := TPedidoVenda.Create(0);
    Result.NumeroPedido := ACodigo;
    Result.DataEmissao := QueryController.FieldByName('data_emissao').AsDateTime;
    Result.CodigoCliente := QueryController.FieldByName('codigo_cliente').AsInteger;
    Result.ValorTotal := QueryController.FieldByName('valor_total').AsCurrency;

    QueryController.Close;
    QueryController.SQL.Clear;
    QueryController.SQL.Add(msItensPedidoVendaByCodigo);
    QueryController.ParamByName('numero_pedido').AsInteger := ACodigo;
    QueryController.Open;

    QueryController.First;
    while not QueryController.Eof do begin

      var Produto := TProdutoVenda.Create;
      Produto.Codigo := QueryController.FieldByName('codigo_produto').AsInteger;
      Produto.Descricao := QueryController.FieldByName('descricao').AsString;
      Produto.Quantidade := QueryController.FieldByName('quantidade').AsInteger;
      Produto.PrecoVenda := QueryController.FieldByName('valor_unitario').AsCurrency;
      Produto.ValorTotal := QueryController.FieldByName('valor_total').AsCurrency;

      Result.Produtos.Add(Produto);
      QueryController.Next;
    end;

  except on E: Exception do
    raise;
  end;
end;

function TPedidoVendaController.GravaPedidoVenda(
  APedidoVenda: TPedidoVenda): Integer;
begin
  Result := -1;
  ConnectionController.StartTransaction;
  try
    // Insere Cabecalho
    QueryController.Close;
    QueryController.SQL.Clear;
    QueryController.SQL.Add(msInsertCabecalhoPedido);
    QueryController.ParamByName('data_emissao').AsDate := APedidoVenda.DataEmissao;
    QueryController.ParamByName('codigo_cliente').AsInteger := APedidoVenda.CodigoCliente;    
    QueryController.ParamByName('valor_total').AsCurrency := APedidoVenda.ValorTotal;    
    QueryController.ExecSQL;

    var NumeroPedido := ConnectionController.ExecSQLScalar(msGetLastID);
  
    // Insere Itens
    for var Produto in APedidoVenda.Produtos do begin
      QueryController.Close;
      QueryController.SQL.Clear;
      QueryController.SQL.Add(msInsertItensPedido);
      QueryController.ParamByName('numero_pedido').AsInteger := NumeroPedido;
      QueryController.ParamByName('codigo_produto').AsInteger := Produto.Codigo;
      QueryController.ParamByName('quantidade').AsInteger := Produto.Quantidade;
      QueryController.ParamByName('valor_unitario').AsCurrency := Produto.PrecoVenda;
      QueryController.ParamByName('valor_total').AsCurrency := Produto.ValorTotal;            
      QueryController.ExecSQL;
    end;

    ConnectionController.Commit;
    Result := NumeroPedido;
  except on E: Exception do
    ConnectionController.Rollback;
  end;
end;

end.
