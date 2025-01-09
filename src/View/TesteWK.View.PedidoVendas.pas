unit TesteWK.View.PedidoVendas;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.ImageList,
  System.UITypes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.ExtCtrls,
  Vcl.StdCtrls,
  Vcl.Grids,
  Vcl.DBGrids,
  Vcl.ImgList,
  Vcl.Mask,
  Data.DB;

resourcestring
  msCancelCaption = 'Cancelamento';
  msCancelPrompt = 'Informe o Número do Pedido a ser Cancelado';
  msCancelInvalido = 'O Número de Pedido informado é inválido.';
  msCancelZerado = 'O Número de Pedido deve ser maior que 0.';

type
  TFrmPedidoVenda = class(TForm)
    pnlCabecalho: TPanel;
    pnlProdutos: TPanel;
    pnlRodape: TPanel;
    grdProdutos: TDBGrid;
    lblValorTotalPedido: TLabel;
    btnGravarPedido: TButton;
    ilImagens: TImageList;
    edtCodProduto: TLabeledEdit;
    edtQuantidade: TLabeledEdit;
    edtValorUnitario: TLabeledEdit;
    edtNomeProduto: TEdit;
    btnInserirItem: TButton;
    edtCodCliente: TLabeledEdit;
    edtNomeCliente: TEdit;
    edtDataEmissao: TLabeledEdit;
    edtNumeroPedido: TLabeledEdit;
    btnCancelarPedido: TButton;
    procedure btnCancelarPedidoClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPedidoVenda: TFrmPedidoVenda;

implementation

{$R *.dfm}

procedure TFrmPedidoVenda.btnCancelarPedidoClick(Sender: TObject);
begin
  var lNumeroPedido := InputBox(msCancelCaption, msCancelPrompt, '0');
  try
    var lNumeroPedidoConvertido := 0;
    if not TryStrToInt(lNumeroPedido, lNumeroPedidoConvertido) then
      raise Exception.Create(msCancelInvalido);

    if lNumeroPedidoConvertido <= 0 then
      raise Exception.Create(msCancelZerado);
  except on E: Exception do
    MessageDlg(E.Message, TMsgDlgType.mtError, [mbOk], 0);
  end;
end;

end.
