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
  Data.DB,
  TesteWK.Model.Clientes,
  TesteWK.Model.Produtos,
  TesteWK.Model.PedidoVendas,
  TesteWK.Controller.Clientes,
  TesteWK.Controller.Produtos, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

resourcestring
  msCancelCaption = 'Cancelamento';
  msCancelPrompt = 'Informe o Número do Pedido a ser Cancelado';
  msCancelInvalido = 'O Número de Pedido informado é inválido.';
  msCancelZerado = 'O Número de Pedido deve ser maior que 0.';
  msPedidoGravadoSucesso = 'Pedido de Venda gravado com Sucesso.';
  msPedidoClienteInvalido = 'O Código do Cliente deve ser maior que 0.';
  msPedidoInvalido = 'Houve um erro ao criar o pedido, por favor tente novamente.';
  msPedidoProdutoInvalido = 'O Código do Produto deve ser maior que 0.';
  msPedidoDeletaProduto = 'Deseja realmente deletar o produto selecionado do pedido?';
  msLabelValorTotal = 'Valor Total: %m';

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
    dsPedidoProdutos: TDataSource;
    mmProdutosTemp: TFDMemTable;
    mmProdutosTempCodigoProduto: TIntegerField;
    mmProdutosTempDescricao: TStringField;
    mmProdutosTempPrecoVenda: TCurrencyField;
    mmProdutosTempQuantidade: TIntegerField;
    procedure btnCancelarPedidoClick(Sender: TObject);
    procedure btnGravarPedidoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edtCodClienteExit(Sender: TObject);
    procedure edtCodProdutoExit(Sender: TObject);
    procedure btnInserirItemClick(Sender: TObject);
    procedure grdProdutosKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    FCliente : TCliente;
    FPedido : TPedidoVenda;
    FControllerCliente : TClienteController;
    FControllerProduto : TProdutoController;
//    FControllerPedido  : TPedidoController;
    FValorTotal : Currency;
    procedure LimpaCampos;
    procedure LimpaCamposCabecalho;
    procedure LimpaCamposProdutos;
    procedure RecalculaTotal;
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

procedure TFrmPedidoVenda.btnGravarPedidoClick(Sender: TObject);
begin
  MessageDlg(msPedidoGravadoSucesso, mtInformation, [mbOK], 0);
  LimpaCampos;
end;

procedure TFrmPedidoVenda.btnInserirItemClick(Sender: TObject);
begin
  if not mmProdutosTemp.Active then
    mmProdutosTemp.Open;

  if mmProdutosTemp.State <> dsEdit then
    mmProdutosTemp.Append;

  mmProdutosTemp.FieldByName('CodigoProduto').AsInteger := StrToInt(edtCodProduto.Text);
  mmProdutosTemp.FieldByName('Descricao').AsString := edtNomeProduto.Text;
  mmProdutosTemp.FieldByName('Quantidade').AsInteger := StrToInt(edtQuantidade.Text);
  mmProdutosTemp.FieldByName('PrecoVenda').AsCurrency := StrToCurr(edtValorUnitario.Text);
  mmProdutosTemp.Post;

  LimpaCamposProdutos;
  RecalculaTotal;
end;

procedure TFrmPedidoVenda.edtCodClienteExit(Sender: TObject);
var
  lCodigo : Integer;
begin

  try
    if TryStrToInt(edtCodCliente.Text, lCodigo) then begin

      if lCodigo <= 0 then
        raise Exception.Create(msPedidoClienteInvalido);

      if Assigned(FCliente) then
        FreeAndNil(FCliente);

      FCliente := FControllerCliente.GetClienteByCodigo(lCodigo);
      if Assigned(FCliente) then
        edtNomeCliente.Text := FCliente.Nome;

      if Assigned(FPedido) then
        FreeAndNil(FPedido);

      FPedido := TPedidoVenda.Create(FCliente.Codigo);
      if Assigned(FPedido) then
        edtDataEmissao.Text := DateToStr(FPedido.DataEmissao);

      btnCancelarPedido.Visible := lCodigo <= 0;
      btnGravarPedido.Visible := True;

    end;
  except on E: Exception do
    begin
      LimpaCamposCabecalho;
      MessageDlg(E.Message, TMsgDlgType.mtError, [mbOk], 0);
    end;
  end;

end;

procedure TFrmPedidoVenda.edtCodProdutoExit(Sender: TObject);
var
  lCodigo : Integer;
begin

  try
    if TryStrToInt(edtCodProduto.Text, lCodigo) then begin

      if lCodigo <= 0 then
        raise Exception.Create(msPedidoProdutoInvalido);

      var Produto := FControllerProduto.GetProdutoByCodigo(lCodigo);
      if Assigned(Produto) then begin
        edtNomeProduto.Text := Produto.Descricao;
        edtQuantidade.Text := '1';
        edtValorUnitario.Text := Produto.PrecoVenda.ToString();
      end;

    end;
  except on E: Exception do
    begin
      LimpaCamposProdutos;
      MessageDlg(E.Message, TMsgDlgType.mtError, [mbOk], 0);
    end;
  end;
end;

procedure TFrmPedidoVenda.FormCreate(Sender: TObject);
begin
  FValorTotal := 0;
  FControllerCliente := TClienteController.Create;
  FControllerProduto := TProdutoController.Create;
//  FControllerPedido  := TPedidoController.Create;
end;

procedure TFrmPedidoVenda.grdProdutosKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of

    VkDelete : begin
      if MessageDlg(msPedidoDeletaProduto, mtConfirmation, mbYesNo, 0) = mrYes then
        mmProdutosTemp.Delete;
    end;

    vkReturn : begin
      edtCodProduto.Text := mmProdutosTemp.FieldByName('CodigoProduto').AsString;
      edtNomeProduto.Text := mmProdutosTemp.FieldByName('Descricao').AsString;
      edtQuantidade.Text := mmProdutosTemp.FieldByName('Quantidade').AsString;
      edtValorUnitario.Text := mmProdutosTemp.FieldByName('PrecoVenda').AsString;

      edtCodProduto.ReadOnly := True;
      mmProdutosTemp.Edit;
    end;

  end;
end;

procedure TFrmPedidoVenda.LimpaCampos;
begin
  btnCancelarPedido.Visible := True;
  btnGravarPedido.Visible := False;
  mmProdutosTemp.Close;

  LimpaCamposProdutos;
  LimpaCamposCabecalho;
end;

procedure TFrmPedidoVenda.LimpaCamposCabecalho;
begin
  edtNumeroPedido.Clear;
  edtCodCliente.Clear;
  edtNomeCliente.Clear;
  edtDataEmissao.Clear;

  edtCodCliente.SetFocus;
end;

procedure TFrmPedidoVenda.LimpaCamposProdutos;
begin
  edtCodProduto.Clear;
  edtNomeProduto.Clear;
  edtQuantidade.Clear;
  edtValorUnitario.Clear;

  edtCodProduto.ReadOnly := False;
  edtCodProduto.SetFocus;
end;

procedure TFrmPedidoVenda.RecalculaTotal;
begin
  FValorTotal := 0;
  mmProdutosTemp.DisableControls;
  try
    mmProdutosTemp.First;
    while not mmProdutosTemp.Eof do begin
      FValorTotal := FValorTotal + mmProdutosTemp.FieldByName('Quantidade').AsInteger * mmProdutosTemp.FieldByName('PrecoVenda').AsCurrency;
      mmProdutosTemp.Next;
    end;
  finally
    mmProdutosTemp.EnableControls;
    lblValorTotalPedido.Caption := Format(msLabelValorTotal, [FValorTotal]);
  end;

end;

end.
