program AppDogao;

uses
  System.StartUpCopy,
  FMX.Forms,
  uPrincipal in 'uPrincipal.pas' {fPrincipal},
  uAcesso in 'uAcesso.pas' {fAcesso},
  uDataModule in 'uDataModule.pas' {Dm: TDataModule},
  uDadosPerfil in 'uDadosPerfil.pas' {fDadosPerfil};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TDm, Dm);
  Application.CreateForm(TfAcesso, fAcesso);
  Application.CreateForm(TfDadosPerfil, fDadosPerfil);
  Application.Run;
end.
