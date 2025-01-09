unit TesteWK.Model.Produtos;

interface
type
  TProduto = class
  private
    FCodigo: Integer;
    FDescricao: String;
    FPrecoVenda: Currency;
  public
    property Codigo: Integer read FCodigo write FCodigo;
    property Descricao: String read FDescricao write FDescricao;
    property PrecoVenda: Currency read FPrecoVenda write FPrecoVenda;
  end;

implementation

end.
