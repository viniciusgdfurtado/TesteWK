program TesteWK;

uses
  Vcl.Forms,
  TesteWK.View.PedidoVendas in 'View\TesteWK.View.PedidoVendas.pas' {Form1},
  TesteWK.Model.Clientes in 'Model\TesteWK.Model.Clientes.pas',
  TesteWK.Model.Produtos in 'Model\TesteWK.Model.Produtos.pas',
  TesteWK.Model.PedidoVendas in 'Model\TesteWK.Model.PedidoVendas.pas',
  TesteWK.Controller.PedidoVendas in 'Controller\TesteWK.Controller.PedidoVendas.pas',
  TesteWK.Controller.Clientes in 'Controller\TesteWK.Controller.Clientes.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
