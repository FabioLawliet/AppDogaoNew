unit uCadBasico;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.Edit, FMX.Layouts, FMX.StdCtrls, IdHashSHA, FMX.DialogService;

type
  TfCadBasico = class(TForm)
    RectLogin: TRectangle;
    edtEmail: TEdit;
    Label1: TLabel;
    LayEmail: TLayout;
    LaySenha: TLayout;
    Label2: TLabel;
    Rectangle1: TRectangle;
    edtSenha: TEdit;
    LayRepetirSenha: TLayout;
    Label3: TLabel;
    Rectangle2: TRectangle;
    edtSenha2: TEdit;
    LayName: TLayout;
    Label4: TLabel;
    Rectangle3: TRectangle;
    edtNome: TEdit;
    RectEntrar: TRectangle;
    Label11: TLabel;
    LayConfirmar: TLayout;
    ImageEyeClose: TImage;
    LayPrincipal: TLayout;
    LayoutCompleto: TLayout;
    VertScrollBox1: TVertScrollBox;
    LayLogo: TLayout;
    DogaoLanchesLogo: TImage;
    ImageEyeOpen: TImage;
    LayEye: TLayout;
    procedure RectEntrarClick(Sender: TObject);
    procedure LayEyeClick(Sender: TObject);
  private
    function SHA1FromString(const AString: string): string;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fCadBasico: TfCadBasico;

implementation

uses
  uDataModule;

{$R *.fmx}

function TfCadBasico.SHA1FromString(const AString: string): string;
var
  SHA1: TIdHashSHA1;
begin
  SHA1 := TIdHashSHA1.Create;
  try
    Result := SHA1.HashStringAsHex(AString);
  finally
    SHA1.Free;
  end;
end;

procedure TfCadBasico.LayEyeClick(Sender: TObject);
begin
  if ImageEyeClose.Visible then
  begin
    ImageEyeClose.Visible := False;
    ImageEyeOpen.Visible := True;
    edtSenha.Password := False;
    edtSenha2.Password := False;
  end else
  begin
    ImageEyeClose.Visible := True;
    ImageEyeOpen.Visible := False;
    edtSenha.Password := True;
    edtSenha2.Password := True;
  end;
end;

procedure TfCadBasico.RectEntrarClick(Sender: TObject);
begin
  if edtNome.Text = '' then
  begin
    ShowMessage('Informe um nome!');
    exit;
  end;

  if edtNome.Text = '' then
  begin
    ShowMessage('Informe um email!');
    exit;
  end;

  if edtSenha.Text <> edtSenha2.Text then
  begin
    ShowMessage('As senhas informadas não sao iguais!');
    exit;
  end;

  dm.QueryPessoa.Close();
  dm.QueryPessoa.Open();
  dm.QueryPessoa.Append;
  dm.QueryPessoaNome.AsString := edtNome.Text;
  dm.QueryPessoaEmail.AsString := edtEmail.Text;
  dm.QueryPessoaSenha.AsString := SHA1FromString(edtSenha.Text);
  dm.QueryPessoa.Post;
  dm.FDConnection.CommitRetaining;
  Close();
end;

end.
