unit uAcesso;

interface

uses
  System.Types, System.UITypes, System.Classes, System.Variants, FireDAC.Stan.Param,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl,
  FMX.Objects, FMX.Edit, FMX.Layouts, FMX.Controls.Presentation, FMX.StdCtrls, uCadBasico,
  System.SysUtils, IdHashSHA, FMX.VirtualKeyboard, FMX.Platform, uDataModule;

type
  TfAcesso = class(TForm)
    TabControl: TTabControl;
    Tab01_Logo: TTabItem;
    DogaoLanchesLogo: TImage;
    lbCliqueAqui: TLabel;
    Tab02_Login: TTabItem;
    LayoutCompleto: TLayout;
    LayLogin: TLayout;
    LayEntrar: TLayout;
    RectEntrar: TRectangle;
    Label11: TLabel;
    LayEmail: TLayout;
    RectLogin: TRectangle;
    edtEmail: TEdit;
    ImgUser: TImage;
    LaySenha: TLayout;
    RectPassword: TRectangle;
    edtSenha: TEdit;
    ImgPassword: TImage;
    LayEye: TLayout;
    ImageEyeClose: TImage;
    ImageEyeOpen: TImage;
    lbCadastreSe: TLabel;
    LayLogo: TLayout;
    Image1: TImage;
    Tab03_Cadastro: TTabItem;
    VertScrollBox1: TVertScrollBox;
    Layout1: TLayout;
    LayPrincipal: TLayout;
    LayConfirmar: TLayout;
    Rectangle1: TRectangle;
    Label1: TLabel;
    Layout2: TLayout;
    Label2: TLabel;
    Rectangle2: TRectangle;
    Tab03_edtemail: TEdit;
    LayName: TLayout;
    Label4: TLabel;
    Rectangle3: TRectangle;
    Tab03_edtNome: TEdit;
    LayRepetirSenha: TLayout;
    Label3: TLabel;
    Rectangle4: TRectangle;
    Tab03_edtSenha2: TEdit;
    Layout3: TLayout;
    Label5: TLabel;
    Rectangle5: TRectangle;
    Tab03_edtSenha: TEdit;
    Tab03_LayEye: TLayout;
    Tab03_ImageEyeClose: TImage;
    Tab03_ImageEyeOpen: TImage;
    Layout5: TLayout;
    Image4: TImage;
    procedure LayEyeClick(Sender: TObject);
    procedure RectEntrarClick(Sender: TObject);
    procedure Tab03_LayEyeClick(Sender: TObject);
    procedure lbCadastreSeClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure DogaoLanchesLogoClick(Sender: TObject);
    procedure Rectangle1Click(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
  private
    function SHA1FromString(const AString: string): string;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fAcesso: TfAcesso;

implementation

uses
  uPrincipal;

{$R *.fmx}

procedure TfAcesso.DogaoLanchesLogoClick(Sender: TObject);
begin
  TabControl.ActiveTab := Tab02_Login;
  Tab02_Login.Visible := True;
  Tab01_Logo.Visible := False;
end;

procedure TfAcesso.FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
  Shift: TShiftState);
  {$IFDEF ANDROID}
var
  FService: IFMXVirtualKeyboardService;
  {$ENDIF}
begin
  {$IFDEF ANDROID}
    if (Key = vkHardWareBack) then
    begin
      TPlatformServices.Current.SupportsPlatformService(IFMXVirtualKeyboardService, IInterface(FService));

      if (FService <> nil) and (TVirtualKeyBoardState.Visible in FService.VirtualKeyBoardState) then
      begin
        //Teclado virtual aberto.
      end else
      begin
        if (TabControl.ActiveTab = Tab03_Cadastro) then
        begin
          Key := 0;
          TabControl.ActiveTab := Tab02_Login;
        end;
      end;
    end;
  {$ENDIF}
end;

procedure TfAcesso.FormShow(Sender: TObject);
begin
  TabControl.ActiveTab := Tab01_Logo;
  Tab02_Login.Visible := False;
  Tab03_Cadastro.Visible := False;

  //{$IFDEF DEBUG}
  //  FAcesso.Visible := False;
  //  if not assigned(FPrincipal) then
  //    Application.CreateForm(TFPrincipal, FPrincipal);
  //
  //  FPrincipal.Show;
  //{$IFEND"}}
end;

procedure TfAcesso.LayEyeClick(Sender: TObject);
begin
  if ImageEyeClose.Visible then
  begin
    ImageEyeClose.Visible := False;
    ImageEyeOpen.Visible := True;
    edtSenha.Password := False;
  end else
  begin
    ImageEyeClose.Visible := True;
    ImageEyeOpen.Visible := False;
    edtSenha.Password := True;
  end;
end;

function TfAcesso.SHA1FromString(const AString: string): string;
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

procedure TfAcesso.Tab03_LayEyeClick(Sender: TObject);
begin
  if tab03_ImageEyeClose.Visible then
  begin
    tab03_ImageEyeClose.Visible := False;
    tab03_ImageEyeOpen.Visible := True;
    tab03_edtSenha.Password := False;
    tab03_edtSenha2.Password := False;
  end else
  begin
    tab03_ImageEyeClose.Visible := True;
    tab03_ImageEyeOpen.Visible := False;
    tab03_edtSenha.Password := True;
    tab03_edtSenha2.Password := True;
  end;
end;

procedure TfAcesso.lbCadastreSeClick(Sender: TObject);
begin
  TabControl.ActiveTab := Tab03_Cadastro;
  Tab03_Cadastro.Visible := True;
  edtEmail.Text := '';
  edtSenha.Text := '';
end;

procedure TfAcesso.Rectangle1Click(Sender: TObject);
begin
  if Tab03_edtNome.Text = '' then
  begin
    ShowMessage('Informe um nome!');
    exit;
  end;

  if Tab03_edtemail.Text = '' then
  begin
    ShowMessage('Informe um email!');
    exit;
  end;

  if Tab03_edtSenha.Text <> Tab03_edtSenha2.Text then
  begin
    ShowMessage('As senhas informadas não sao iguais!');
    exit;
  end;

  dm.QueryPessoa.Close();
  dm.QueryPessoa.Open();
  dm.QueryPessoa.Filter := 'email = ' + Tab03_edtemail.Text;
  dm.QueryPessoa.Filtered := True;

  if (dm.QueryPessoa.RecordCount = 0) then
  begin
    dm.QueryPessoa.Append;
    dm.QueryPessoaNome.AsString := Tab03_edtNome.Text;
    dm.QueryPessoaEmail.AsString := Tab03_edtEmail.Text;
    dm.QueryPessoaSenha.AsString := SHA1FromString(Tab03_edtSenha.Text);
    dm.QueryPessoa.Post;
    dm.FDConnection.CommitRetaining;
  end else
  begin
    ShowMessage('O email ' + Tab03_edtemail.Text + ' já foi cadastrado! Escolha outro e-mail.');
    dm.QueryPessoa.Filtered := False;
    Exit;
  end;

  ShowMessage('Cadastro realizado com sucesso!');

  TabControl.ActiveTab := Tab02_Login;
  Tab03_Cadastro.Visible := False;
end;

procedure TfAcesso.RectEntrarClick(Sender: TObject);
const cSql = 'select * from Pessoa where email = :email and senha = :senha';
begin
  dm.QueryPessoa.Close;
  dm.QueryPessoa.SQL.Clear;
  dm.QueryPessoa.SQL.Add(cSQL);
  dm.QueryPessoa.ParamByName('email').AsString := edtEmail.Text;
  dm.QueryPessoa.ParamByName('senha').AsString := SHA1FromString(edtSenha.Text);
  dm.QueryPessoa.Open();

  if (not dm.QueryPessoa.IsEmpty) then
  begin
    dm.idPessoaLogada := dm.QueryPessoaid.AsInteger;
    if not assigned(FPrincipal) then
      Application.CreateForm(TFPrincipal, FPrincipal);

    FPrincipal.Show;
  end else
  begin
    ShowMessage('Email ou senha inválido!');
  end;
end;

end.
