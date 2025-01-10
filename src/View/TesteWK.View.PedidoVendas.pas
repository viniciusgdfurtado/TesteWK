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
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Param,
  FireDAC.Stan.Error,
  FireDAC.DatS,
  FireDAC.Phys.Intf,
  FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,
  TesteWK.Model.Clientes,
  TesteWK.Model.Produtos,
  TesteWK.Model.PedidoVendas,
  TesteWK.Controller.Clientes,
  TesteWK.Controller.Produtos,
  TesteWK.Controller.PedidoVendas;

resourcestring
  msCancelCaption = 'Cancelamento';
  msCancelPrompt = 'Informe o Número do Pedido a ser Cancelado';
  msNumeroPedidoInvalido = 'O Número de Pedido informado é inválido.';
  msNumeroPedidoZerado = 'O Número de Pedido deve ser maior que 0.';
  msPedidoGravadoSucesso = 'Pedido de Venda N°.: %s gravado com Sucesso.';
  msPedidoClienteInvalido = 'O Código do Cliente deve ser maior que 0.';
  msPedidoInvalido = 'Houve um erro ao criar o pedido, por favor tente novamente.';
  msPedidoProdutoInvalido = 'O Código do Produto deve ser maior que 0.';
  msPedidoDeletaProduto = 'Deseja realmente deletar o produto selecionado do pedido?';
  msLabelValorTotal = 'Valor Total: %m';
  msPedidoFalhaCancelar = 'Houve um erro ao tentar cancelar o Pedido, tente novamente.';
  msPedidoCancelado = 'Pedido N°.: %s cancelado com sucesso.';
  msPedidoSemItens = 'Por favor insira os itens antes de gravar o Pedido.';
  msPedidoFalhaGravar = 'Houve um erro ao tentar gravar o Pedido, tente novamente.';
  msVisualizacaoPedidoCaption = 'Consulta';
  msVisualizacaoPedidoPrompt = 'Informe o Número do Pedido a ser visualizado.';
  msCodigoProdutoInvalido = 'Por favor verifique o produto informado.';
  msQuantidadeProdutoInvalido = 'Por favor verifique a quantidade do produto informado.';
  msPrecoVendaProdutoInvalido = 'Por favor verifique o preço de venda do produto informado.';
  msConfirmacaoSaida = 'Existe um pedido em edição, deseja realmente sair?';

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
    mmProdutosTempValorTotal: TCurrencyField;
    btnVisualizarPedido: TButton;
    btnNovoPedido: TButton;
    btnCancelar: TButton;
    procedure FormCreate(Sender: TObject);
    procedure edtCodClienteExit(Sender: TObject);
    procedure edtCodProdutoExit(Sender: TObject);
    procedure btnCancelarPedidoClick(Sender: TObject);
    procedure btnVisualizarPedidoClick(Sender: TObject);
    procedure btnGravarPedidoClick(Sender: TObject);
    procedure btnInserirItemClick(Sender: TObject);
    procedure grdProdutosKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnNovoPedidoClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
    FCliente : TCliente;
    FPedido : TPedidoVenda;
    FProduto : TProduto;
    FControllerCliente : TClienteController;
    FControllerProduto : TProdutoController;
    FControllerPedido  : TPedidoVendaController;
    procedure LimparCampos;
    procedure LimparCamposCabecalho;
    procedure LimparCamposProdutos;
    procedure ResetaCamposTela;
    procedure RecalculaTotal;
    procedure CarregarPedido(ANumeroPedido : String);
    procedure CarregarCliente(ACodigo : String);
    procedure CarregarProduto(ACodigo : String);
    procedure PopulaPedido(APedido : TPedidoVenda);
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
      raise Exception.Create(msNumeroPedidoInvalido);

    if lNumeroPedidoConvertido <= 0 then
      raise Exception.Create(msNumeroPedidoZerado);

    if not FControllerPedido.CancelaPedidoVendaByNumero(lNumeroPedidoConvertido) then
      raise Exception.Create(msPedidoFalhaCancelar);

    MessageDlg(Format(msPedidoCancelado, [lNumeroPedidoConvertido.ToString()]), mtInformation, [mbOk], 0);

  except on E: Exception do
    MessageDlg(E.Message, TMsgDlgType.mtError, [mbOk], 0);
  end;
end;

procedure TFrmPedidoVenda.btnGravarPedidoClick(Sender: TObject);
begin
  try  
    if not Assigned(FCliente) then
      raise Exception.Create(msPedidoClienteInvalido);

    if not Assigned(FPedido) then 
      raise Exception.Create(msPedidoInvalido);

    FPedido.CodigoCliente := FCliente.Codigo;
    RecalculaTotal;

    if FPedido.ValorTotal <= 0 then
      raise Exception.Create(msPedidoSemItens);

    if mmProdutosTemp.Active then begin

      if mmProdutosTemp.RecordCount <= 0 then
        raise Exception.Create(msPedidoSemItens);
    
      mmProdutosTemp.DisableControls;
      try
        mmProdutosTemp.First;
        while not mmProdutosTemp.Eof do begin

          var Produto := TProdutoVenda.Create;
          Produto.Codigo := mmProdutosTemp.FieldByName('CodigoProduto').AsInteger;
          Produto.Descricao := mmProdutosTemp.FieldByName('Descricao').AsString;
          Produto.Quantidade := mmProdutosTemp.FieldByName('Quantidade').AsInteger;
          Produto.PrecoVenda := mmProdutosTemp.FieldByName('PrecoVenda').AsCurrency;
          Produto.ValorTotal := mmProdutosTemp.FieldByName('ValorTotal').AsCurrency;

          FPedido.Produtos.Add(Produto);
          mmProdutosTemp.Next;
        end;
      finally
        mmProdutosTemp.EnableControls;
      end;
    end;

    var NumeroPedido := FControllerPedido.GravaPedidoVenda(FPedido);
    if NumeroPedido <= 0 then
      raise Exception.Create(msPedidoFalhaGravar);

    MessageDlg(Format(msPedidoGravadoSucesso, [NumeroPedido.ToString()]), mtInformation, [mbOK], 0);
    ResetaCamposTela;

  except on E: Exception do
    MessageDlg(E.Message, TMsgDlgType.mtError, [mbOk], 0);
  end;
end;

procedure TFrmPedidoVenda.btnInserirItemClick(Sender: TObject);
begin
  try
    if Trim(edtNumeroPedido.Text).IsEmpty then begin

      if Trim(edtCodProduto.Text).IsEmpty then
        raise Exception.Create(msCodigoProdutoInvalido);

      if ((Trim(edtQuantidade.Text).IsEmpty) or (strToInt(edtQuantidade.Text) = 0)) then
        raise Exception.Create(msQuantidadeProdutoInvalido);

      if ((Trim(edtValorUnitario.Text).IsEmpty) or (strToInt(edtQuantidade.Text) = 0)) then
        raise Exception.Create(msPrecoVendaProdutoInvalido);

      if not mmProdutosTemp.Active then
        mmProdutosTemp.Open;

      if mmProdutosTemp.State <> dsEdit then
        mmProdutosTemp.Append;

      mmProdutosTemp.FieldByName('CodigoProduto').AsInteger := StrToInt(edtCodProduto.Text);
      mmProdutosTemp.FieldByName('Descricao').AsString := edtNomeProduto.Text;
      mmProdutosTemp.FieldByName('Quantidade').AsInteger := StrToInt(edtQuantidade.Text);
      mmProdutosTemp.FieldByName('PrecoVenda').AsCurrency := StrToCurr(edtValorUnitario.Text);
      mmProdutosTemp.FieldByName('ValorTotal').AsCurrency := mmProdutosTemp.FieldByName('Quantidade').AsInteger *  mmProdutosTemp.FieldByName('PrecoVenda').AsCurrency;
      mmProdutosTemp.Post;

      LimparCamposProdutos;
      RecalculaTotal;
    end;
  except on E: Exception do
    MessageDlg(E.Message, TMsgDlgType.mtError, [mbOk], 0);
  end;
end;

procedure TFrmPedidoVenda.btnNovoPedidoClick(Sender: TObject);
begin
  LimparCampos;

  if Assigned(FPedido) then
    FreeAndNil(FPedido);

  if Assigned(FCliente) then
    FreeAndNil(FCliente);

  if Assigned(FProduto) then
    FreeAndNil(FProduto);

  FPedido := TPedidoVenda.Create(0);

  btnCancelarPedido.Visible := False;
  btnVisualizarPedido.Visible := False;
  btnNovoPedido.Visible := False;
  btnCancelar.Visible := True;
  btnGravarPedido.Visible := True;

  edtDataEmissao.Text := DateToStr(Now);
end;

procedure TFrmPedidoVenda.btnVisualizarPedidoClick(Sender: TObject);
begin
  try
    var NumeroPedido := InputBox(msVisualizacaoPedidoCaption, msVisualizacaoPedidoPrompt, '0');
    CarregarPedido(NumeroPedido);
  except on E: Exception do
    MessageDlg(E.Message, TMsgDlgType.mtError, [mbOk], 0);
  end;
end;

procedure TFrmPedidoVenda.btnCancelarClick(Sender: TObject);
begin
  ResetaCamposTela;
end;

procedure TFrmPedidoVenda.edtCodClienteExit(Sender: TObject);
begin
  try
    if Trim(edtNumeroPedido.Text).IsEmpty and not Trim(edtCodCliente.Text).IsEmpty then
      CarregarCliente(edtCodCliente.Text);
  except on E: Exception do
    begin
      LimparCamposCabecalho;
      MessageDlg(E.Message, TMsgDlgType.mtError, [mbOk], 0);
    end;
  end;
end;

procedure TFrmPedidoVenda.CarregarCliente(ACodigo: String);
begin
  if Assigned(FCliente) then
    FreeAndNil(FCliente);

  FCliente := FControllerCliente.GetClienteByCodigo(StrToInt(ACodigo));
  edtNomeCliente.Text := FCliente.Nome;
end;

procedure TFrmPedidoVenda.CarregarPedido(ANumeroPedido : String);
begin
  if Assigned(FPedido) then
    FreeAndNil(FPedido);

  FPedido := FControllerPedido.GetPedidoVendaByNumero(StrToInt(ANumeroPedido));
  CarregarCliente(FPedido.CodigoCliente.ToString);
  PopulaPedido(FPedido);
end;

procedure TFrmPedidoVenda.PopulaPedido(APedido: TPedidoVenda);
begin
  LimparCampos;

  edtNumeroPedido.Text := APedido.NumeroPedido.ToString;
  edtDataEmissao.Text := DateToStr(APedido.DataEmissao);
  edtCodCliente.Text := FCliente.Codigo.ToString;
  edtNomeCliente.Text := FCliente.Nome;

  if not mmProdutosTemp.Active then
    mmProdutosTemp.Open;

  mmProdutosTemp.DisableControls;
  try
    for var Produto in FPedido.Produtos do begin
      mmProdutosTemp.Append;
      mmProdutosTemp.FieldByName('CodigoProduto').AsInteger := Produto.Codigo;
      mmProdutosTemp.FieldByName('Descricao').AsString := Produto.Descricao;
      mmProdutosTemp.FieldByName('Quantidade').AsInteger := Produto.Quantidade;
      mmProdutosTemp.FieldByName('PrecoVenda').AsCurrency := Produto.PrecoVenda;
      mmProdutosTemp.FieldByName('ValorTotal').AsCurrency := Produto.ValorTotal;
      mmProdutosTemp.Post;
    end;
  finally
    mmProdutosTemp.EnableControls;
    RecalculaTotal;
  end;

  btnCancelarPedido.Visible := False;
  btnVisualizarPedido.Visible := False;
  btnGravarPedido.Visible := False;
  btnCancelar.Visible := False;
  btnNovoPedido.Visible := True;

  edtCodProduto.ReadOnly := True;
  edtQuantidade.ReadOnly := True;
  edtValorUnitario.ReadOnly := True;
  edtCodCliente.ReadOnly := True;

end;

procedure TFrmPedidoVenda.edtCodProdutoExit(Sender: TObject);
begin
  try
    if Trim(edtNumeroPedido.Text).IsEmpty and not Trim(edtCodProduto.Text).IsEmpty then
      CarregarProduto(edtCodProduto.Text);
  except on E: Exception do
    begin
      LimparCamposProdutos;
      MessageDlg(E.Message, TMsgDlgType.mtError, [mbOk], 0);
    end;
  end;
end;

procedure TFrmPedidoVenda.CarregarProduto(ACodigo: String);
begin
  if Assigned(FProduto) then
    FreeAndNil(FProduto);

  FProduto := FControllerProduto.GetProdutoByCodigo(StrToInt(ACodigo));
  if mmProdutosTemp.State in [dsBrowse, dsInactive] then begin
    edtNomeProduto.Text := FProduto.Descricao;
    edtQuantidade.Text := '1';
    edtValorUnitario.Text := FProduto.PrecoVenda.ToString();
  end;
end;

procedure TFrmPedidoVenda.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if Assigned(FPedido) and Trim(edtNumeroPedido.Text).IsEmpty then
    CanClose := MessageDlg(msConfirmacaoSaida, mtConfirmation, mbYesNo, 0) = mrYes;
end;

procedure TFrmPedidoVenda.FormCreate(Sender: TObject);
begin
  FControllerCliente := TClienteController.Create;
  FControllerProduto := TProdutoController.Create;
  FControllerPedido  := TPedidoVendaController.Create;
end;

procedure TFrmPedidoVenda.grdProdutosKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Trim(edtNumeroPedido.Text).IsEmpty and mmProdutosTemp.Active then begin

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
end;

procedure TFrmPedidoVenda.LimparCampos;
begin

  btnCancelarPedido.Visible := True;
  btnVisualizarPedido.Visible := True;
  btnGravarPedido.Visible := False;
  btnCancelar.Visible := False;
  btnNovoPedido.Visible := True;

  mmProdutosTemp.Close;

  LimparCamposProdutos;
  LimparCamposCabecalho;

  RecalculaTotal;
end;

procedure TFrmPedidoVenda.LimparCamposCabecalho;
begin
  edtNumeroPedido.Clear;
  edtCodCliente.Clear;
  edtNomeCliente.Clear;
  edtDataEmissao.Clear;

  edtCodCliente.ReadOnly := False;
  edtCodCliente.SetFocus;
end;

procedure TFrmPedidoVenda.LimparCamposProdutos;
begin
  edtCodProduto.Clear;
  edtNomeProduto.Clear;
  edtQuantidade.Clear;
  edtValorUnitario.Clear;

  edtCodProduto.ReadOnly := False;
  edtQuantidade.ReadOnly := False;
  edtValorUnitario.ReadOnly := False;

  edtCodProduto.SetFocus;
end;

procedure TFrmPedidoVenda.RecalculaTotal;
begin
  lblValorTotalPedido.Caption := 'Valor Total: R$ 0,00';
  if Assigned(FPedido) then begin
    FPedido.ValorTotal := 0;
    mmProdutosTemp.DisableControls;
    try
      if mmProdutosTemp.Active then begin
        mmProdutosTemp.First;
        while not mmProdutosTemp.Eof do begin
          FPedido.ValorTotal := FPedido.ValorTotal + mmProdutosTemp.FieldByName('ValorTotal').AsCurrency;
          mmProdutosTemp.Next;
        end;
      end;
    finally
      mmProdutosTemp.EnableControls;
      lblValorTotalPedido.Caption := Format(msLabelValorTotal, [FPedido.ValorTotal]);
    end;
  end;
end;

procedure TFrmPedidoVenda.ResetaCamposTela;
begin
  LimparCampos;

  btnCancelarPedido.Visible := True;
  btnVisualizarPedido.Visible := True;
  btnGravarPedido.Visible := False;
  btnCancelar.Visible := False;
  btnNovoPedido.Visible := True;

  edtCodProduto.ReadOnly := True;
  edtQuantidade.ReadOnly := True;
  edtValorUnitario.ReadOnly := True;
  edtCodCliente.ReadOnly := True;

  if Assigned(FPedido) then
    FreeAndNil(FPedido);

  if Assigned(FCliente) then
    FreeAndNil(FCliente);

  if Assigned(FProduto) then
    FreeAndNil(FProduto);
end;

end.
