program TesteWK;

uses
  Vcl.Forms,
  TesteWK.View.PedidoVendas in 'View\TesteWK.View.PedidoVendas.pas' {FrmPedidoVenda},
  TesteWK.Model.Clientes in 'Model\TesteWK.Model.Clientes.pas',
  TesteWK.Model.Produtos in 'Model\TesteWK.Model.Produtos.pas',
  TesteWK.Model.PedidoVendas in 'Model\TesteWK.Model.PedidoVendas.pas',
  TesteWK.Controller.PedidoVendas in 'Controller\TesteWK.Controller.PedidoVendas.pas',
  TesteWK.Controller.Clientes in 'Controller\TesteWK.Controller.Clientes.pas',
  TesteWK.Controller.Produtos in 'Controller\TesteWK.Controller.Produtos.pas',
  TesteWK.Controller.Base in 'Controller\TesteWK.Controller.Base.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmPedidoVenda, FrmPedidoVenda);
  Application.Run;
end.
