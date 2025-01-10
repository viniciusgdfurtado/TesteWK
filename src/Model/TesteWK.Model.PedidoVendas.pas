unit TesteWK.Model.PedidoVendas;

interface
uses
  System.SysUtils,
  System.Generics.Collections,
  TesteWK.Model.Produtos;

type
  TProdutoVenda = class(TProduto)
  private
    FQuantidade: Integer;
    FValorTotal : Currency;
  public
    property Quantidade: Integer read FQuantidade write FQuantidade;
    property ValorTotal: Currency read FValorTotal write FValorTotal;
  end;

  TPedidoVenda = class
  private
    FNumeroPedido: Integer;
    FDataEmissao: TDate;
    FCodigoCliente: Integer;
    FValorTotal: Currency;
    FProdutos: TObjectList<TProdutoVenda>;
  public
    property NumeroPedido: Integer read FNumeroPedido write FNumeroPedido;
    property DataEmissao: TDate read FDataEmissao write FDataEmissao;
    property CodigoCliente: Integer read FCodigoCliente write FCodigoCliente;
    property ValorTotal: Currency read FValorTotal write FValorTotal;
    property Produtos: TObjectList<TProdutoVenda> read FProdutos write FProdutos;
    constructor Create(ACodigoCliente : Integer);
    destructor Destroy; override;
  end;

implementation

{ TPedidoVenda }

constructor TPedidoVenda.Create(ACodigoCliente : Integer);
begin
  inherited Create;
  FNumeroPedido := 0;
  FDataEmissao := Now;
  FCodigoCliente := ACodigoCliente;
  FValorTotal := 0;
  FProdutos := TObjectList<TProdutoVenda>.Create;
end;

destructor TPedidoVenda.Destroy;
begin
  if Assigned(FProdutos) then
    FreeAndNil(FProdutos);
  inherited;
end;

end.
