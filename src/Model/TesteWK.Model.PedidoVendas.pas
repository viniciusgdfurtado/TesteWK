unit TesteWK.Model.PedidoVendas;

interface
uses
  System.SysUtils,
  System.Generics.Collections,
  TesteWK.Model.Produtos;

type
  TPedidoVenda = class
  private
    FNumeroPedido: Integer;
    FDataEmissao: TDate;
    FCodigoCliente: Integer;
    FValorTotal: Currency;
    FProdutos: TObjectList<TProduto>;
  public
    property NumeroPedido: Integer read FNumeroPedido write FNumeroPedido;
    property DataEmissao: TDate read FDataEmissao write FDataEmissao;
    property CodigoCliente: Integer read FCodigoCliente write FCodigoCliente;
    property ValorTotal: Currency read FValorTotal write FValorTotal;
    property Produtos: TObjectList<TProduto> read FProdutos write FProdutos;
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
  FProdutos := TObjectList<TProduto>.Create;
end;

destructor TPedidoVenda.Destroy;
begin
  if Assigned(FProdutos) then
    FreeAndNil(FProdutos);
  inherited;
end;

end.
