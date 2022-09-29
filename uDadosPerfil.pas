unit uDadosPerfil;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects, IdHashSHA,
  FMX.Edit, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, uDataModule;

type
  TfDadosPerfil = class(TForm)
    VertScrollBox1: TVertScrollBox;
    Layout1: TLayout;
    LayPrincipal: TLayout;
    LayConfirmar: TLayout;
    btConfirmar: TRectangle;
    Label1: TLabel;
    Layout2: TLayout;
    Label2: TLabel;
    Rectangle2: TRectangle;
    edtemail: TEdit;
    LayName: TLayout;
    Label4: TLabel;
    Rectangle3: TRectangle;
    edtNome: TEdit;
    LayRepetirSenha: TLayout;
    Label3: TLabel;
    Rectangle4: TRectangle;
    edtSenha2: TEdit;
    Layout3: TLayout;
    Label5: TLabel;
    Rectangle5: TRectangle;
    edtSenha: TEdit;
    Tab03_SenhaEye: TRectangle;
    Tab03_imgCloseEye: TImage;
    Tab03_imgOpenEye: TImage;
    Layout5: TLayout;
    Image4: TImage;
    Layout4: TLayout;
    Label6: TLabel;
    Rectangle6: TRectangle;
    edtEndereco: TEdit;
    Layout6: TLayout;
    Label7: TLabel;
    Rectangle7: TRectangle;
    edtBairro: TEdit;
    Layout7: TLayout;
    Label8: TLabel;
    Rectangle8: TRectangle;
    edtCidade: TEdit;
    Layout8: TLayout;
    Label9: TLabel;
    Rectangle9: TRectangle;
    edtTelefone: TEdit;
    procedure btConfirmarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    function SHA1FromString(const AString: string): string;
  public
    { Public declarations }
  end;

var
  fDadosPerfil: TfDadosPerfil;

implementation

{$R *.fmx}

function TfDadosPerfil.SHA1FromString(const AString: string): string;
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

procedure TfDadosPerfil.btConfirmarClick(Sender: TObject);
begin
  if edtSenha.Text <> edtSenha2.Text then
  begin
    ShowMessage('As senhas informadas não sao iguais!');
    exit;
  end;

  dm.QueryPessoa.Close;
  dm.QueryPessoa.SQL.Clear;
  dm.QueryPessoa.SQL.Add('Select * from Pessoa where id = :id');
  dm.QueryPessoa.ParamByName('id').AsInteger := dm.idPessoaLogada;
  dm.QueryPessoa.Open();

  if not dm.QueryPessoa.IsEmpty then
  begin
    dm.QueryPessoa.Edit;
    dm.QueryPessoaNome.AsString := edtNome.Text;
    dm.QueryPessoasenha.AsString := SHA1FromString(edtSenha.Text);
    dm.QueryPessoaendereco.AsString := edtEndereco.Text;
    dm.QueryPessoabairro.AsString := edtBairro.Text;
    dm.QueryPessoaCidade.AsString := edtCidade.Text;
    dm.QueryPessoacelular.AsString := edtTelefone.Text;
    dm.QueryPessoa.Post;
    ShowMessage('Cadastro atualizado com sucesso!');
  end else
  begin
    ShowMessage('Houve um erro ao encontrar o usuário');
  end;
end;

procedure TfDadosPerfil.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 inherited;
  ModalResult := mrOk
end;

procedure TfDadosPerfil.FormShow(Sender: TObject);
begin
  dm.QueryPessoa.Close;
  dm.QueryPessoa.SQL.Clear;
  dm.QueryPessoa.SQL.Add('Select * from Pessoa where id = :id');
  dm.QueryPessoa.ParamByName('id').AsInteger := dm.idPessoaLogada;
  dm.QueryPessoa.Open();

  if not dm.QueryPessoa.IsEmpty then
  begin
    edtNome.Text := dm.QueryPessoanome.AsString;
    edtEmail.Text := dm.QueryPessoaemail.AsString;
    edtEndereco.Text := dm.QueryPessoaendereco.AsString;
    edtBairro.Text := dm.QueryPessoabairro.AsString;
    edtCidade.Text := dm.QueryPessoaCidade.AsString;
    edtTelefone.Text := dm.QueryPessoacelular.AsString;
  end else
  begin
    ShowMessage('Houve um erro ao encontrar o usuário');
  end;
end;

end.
