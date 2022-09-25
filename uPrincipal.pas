unit uPrincipal;

interface

uses
  System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, uDataModule,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, uAcesso, FMX.Edit,
  FMX.Layouts, FMX.TabControl, FMX.MultiView, System.ImageList, FMX.ImgList;

type
  TfPrincipal = class(TForm)
    TabControl: TTabControl;
    Tab01_Promoções: TTabItem;
    Tab02_Lanches: TTabItem;
    Tab03_Carrinho: TTabItem;
    RecMenuPesquisa: TRectangle;
    Tab04_FinalizarPedido: TTabItem;
    MultiView1: TMultiView;
    btnMenu: TSpeedButton;
    SpeedButton1: TSpeedButton;
    ImageList: TImageList;
    Layout1: TLayout;
    Image1: TImage;
    SpeedButton3: TSpeedButton;
    Tab02_ScrollBox: TVertScrollBox;
    Rectangle1: TRectangle;
    Rectangle2: TRectangle;
    procedure Tab02_LanchesClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure GetProdutosBase;
    procedure CriarListaDinamicaProdutos(const aProdutoId: Integer; aProdutoNome, aProdutoDescricao: String; aProdutoValor: Currency);
    procedure LimparScrollBox(AScroll: TVertScrollBox);
    procedure RemoveItemEscolhido(Sender: TObject);
    procedure AdicionaItemEscolhido(Sender: TObject);
  public
    { Public declarations }
  end;

var
  fPrincipal: TfPrincipal;

implementation

uses
  System.SysUtils;

{$R *.fmx}

{ TfPrincipal }

procedure TfPrincipal.AdicionaItemEscolhido(Sender: TObject);
begin
  showMessage('adicionar click');
end;

procedure TfPrincipal.CriarListaDinamicaProdutos(const aProdutoId: Integer;
  aProdutoNome, aProdutoDescricao: String; aProdutoValor: Currency);
var
  RectFundo, RectBarraInferior, rect: TRecTangle;
  lbProdutoNome, lbProdutoDescricao, lbQtde, lbPreco: TLabel;
  imgLanche: TImage;
  layPreco, layInteracoes: TLayout;
  btDelete, btAdicionar: TButton;
begin
  //Criando o retangulo de fundo do item
  RectFundo := TRectangle.Create(Tab02_ScrollBox);
  with RectFundo do
  begin
    Align         := TAlignLayout.Top;
    Height        := 110;
    Fill.Color    := TAlphaColors.White;
    Stroke.Kind   := TBrushKind.None;
    Stroke.Color  := $FFD4D5D7;
    Margins.Top   := 10;
    Margins.Left  := 10;
    Margins.Right := 10;
    XRadius       := 8;
    YRadius       := 8;
    TagString     := IntToStr(aProdutoId);
  end;

  //Criando a barra inferior no retangulo de fundo do item.
  RectBarraInferior := TRectangle.Create(RectFundo);
  with RectBarraInferior do
  begin
    Align        := TAlignLayout.Bottom;
    Height       := 45;
    Fill.Color   := $FFF8CB3C; //TAlphaColors.Orange;
    Stroke.Kind  := TBrushKind.Solid;
    Stroke.Color := TAlphaColors.White;
    Sides        := [TSide.Left, TSide.Bottom, TSide.Right];
    XRadius      := 8;
    YRadius      := 8;
    Corners      := [TCorner.BottomLeft, TCorner.BottomRight];
    HitTest      := False;
    RectFundo.AddObject(RectBarraInferior);
  end;

  //Cria imagem do produto.
  imgLanche := TImage.Create(RectFundo);
  with imgLanche do
  begin
    Align := TAlignLayout.Left;
    MultiResBitmap[0].Bitmap := ImageList.Source[0].MultiResBitmap[0].Bitmap;
    Height := 40;
    Width := 40;
    Margins.Left := 20;
    RectFundo.AddObject(imgLanche);
  end;

  //Cria o nome do produto.
  lbProdutoNome := TLabel.Create(RectFundo);
  with lbProdutoNome do
  begin
    Align := TAlignLayout.Client;
    StyledSettings := StyledSettings - [TStyledSetting.Size, TStyledSetting.FontColor, TStyledSetting.Style];
    TextSettings.FontColor := $FF333333;
    Text := aProdutoNome;
    font.Size := 18;
    font.Style := [TFontStyle.fsBold];
    margins.Left := 20;
    margins.Right := 5;
    Width := 200;
    RectFundo.AddObject(lbProdutoNome);
  end;

  //Cria Layout para adionar o preço.
  layPreco := TLayout.Create(RectFundo);
  with layPreco do
  begin
    RectFundo.AddObject(layPreco);
    Align := TAlignLayout.Right;
    Width := 100;
  end;

  //Cria Label do preço do produto.
  lbPreco := TLabel.Create(RectFundo);
  with lbPreco do
  begin
    layPreco.AddObject(lbPreco);
    StyledSettings := StyledSettings - [TStyledSetting.Size, TStyledSetting.FontColor, TStyledSetting.Style];
    TextSettings.FontColor := $FFDF0B0B;
    font.Size := 18;
    TextAlign.taCenter;
    font.Style := [TFontStyle.fsBold];
    Text := 'R$ ' + FormatFloat('#,0.00',aProdutoValor);
    Margins.Left := 5;
    Margins.Right := 5;
    name := 'lbPreco' + IntToStr(aProdutoId);
    Align := TAlignLayout.Client;
  end;

  //Cria Layout para adionar botões de ação.
  layInteracoes := TLayout.Create(RectFundo);
  with layInteracoes do
  begin
    RectFundo.AddObject(layInteracoes);
    Align := TAlignLayout.Right;
    Width := 100;
    Fill.Color := TAlphacolors.Dimgray;
  end;

  //Cria botão para adicionar.
  btAdicionar := TButton.Create(layInteracoes);
  with btAdicionar do
  begin
    layInteracoes.AddObject(btAdicionar);
    StyleLookup := 'AddItemButton';
    TagString := IntToStr(aProdutoId);
    Height := 40;
    Width := 40;
    OnClick := AdicionaItemEscolhido;
    Align := TAlignLayout.Right;
  end;

  //Cria Label Qtde selecionada;
  lbQtde := Tlabel.Create(layInteracoes);
  with lbQtde do
  begin
    layInteracoes.AddObject(lbQtde);
    StyledSettings := StyledSettings - [TStyledSetting.Size, TStyledSetting.FontColor, TStyledSetting.Style];
    TextSettings.FontColor := $FFDF0B0B;
    font.Size := 16;
    TextAlign := TTextAlign.Center;
    font.Style := [TFontStyle.fsBold];
    Text := '0';
    Margins.Left := 5;
    Margins.Right := 5;
    name := 'lbTotal' + IntToStr(aProdutoId);
    Align := TAlignLayout.Client;
  end;

  //Cria botão para remover.
  btDelete := TButton.Create(layInteracoes);
  with btDelete do
  begin
    layInteracoes.AddObject(btDelete);
    StyleLookup := 'DeleteItemButton';
    TagString := IntToStr(aProdutoId);
    Height := 40;
    Width := 40;
    OnClick := RemoveItemEscolhido;
    Align := TAlignLayout.Left;
  end;

  //Cria a Descrição do produto.
  lbProdutoDescricao := TLabel.Create(RectBarraInferior);
  with lbProdutoDescricao do
  begin
    Align := TAlignLayout.Top;
    StyledSettings := StyledSettings - [TStyledSetting.Size, TStyledSetting.FontColor, TStyledSetting.Style];
    TextSettings.FontColor := $FF333333;
    Text := 'Ingredientes: ' + aProdutoDescricao;
    font.Size := 11;
    font.Style := [TFontStyle.fsBold];
    margins.Top := 10;
    margins.Left := 20;
    Width := RectFundo.Width-40;
    RectBarraInferior.AddObject(lbProdutoDescricao);
  end;

  Tab02_ScrollBox.AddObject(RectFundo);
end;

procedure TfPrincipal.FormCreate(Sender: TObject);
begin
  TabControl.ActiveTab := Tab01_Promoções;
end;

procedure TfPrincipal.GetProdutosBase;
begin
  LimparScrollBox(Tab02_ScrollBox);

  dm.QueryProduto.Close;
  dm.QueryProduto.Open();

  dm.QueryProduto.First;
  while not dm.QueryProduto.Eof do
  begin
    CriarListaDinamicaProdutos(dm.QueryProdutoid.AsInteger, dm.QueryProdutoNome.AsString,
      dm.QueryProdutoDescricao.AsString, dm.QueryProdutoValor.AsCurrency);

    dm.QueryProduto.Next;
  end;
end;

procedure TfPrincipal.LimparScrollBox(AScroll: TVertScrollBox);
var i: integer;
begin
  for i := AScroll.ComponentCount-1 downto 0 do
      if AScroll.Components[i] is TRectangle then
         TButton(AScroll.Components[i]).DisposeOf;
end;

procedure TfPrincipal.RemoveItemEscolhido(Sender: TObject);
begin
  showMessage('remover click');
end;

procedure TfPrincipal.Tab02_LanchesClick(Sender: TObject);
begin
  GetProdutosBase;
end;

end.
