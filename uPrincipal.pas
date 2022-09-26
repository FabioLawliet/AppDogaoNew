unit uPrincipal;

interface

uses
  System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, uDataModule,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, uAcesso, FMX.Edit,
  FMX.Layouts, FMX.TabControl, FMX.MultiView, System.ImageList, FMX.ImgList;

type
  TButtonLabel = class(TButton)
    private
      FlbTotal: TLabel;
    published
      property lbTotal: TLabel read FlbTotal write FlbTotal;
      constructor Create(AOwner: TComponent);
  end;

  TfPrincipal = class(TForm)
    TabControl: TTabControl;
    Tab01_Promocoes: TTabItem;
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
    Tab03_ScrollBox: TVertScrollBox;
    Rectangle3: TRectangle;
    Label1: TLabel;
    lbTotalitens2: TLabel;
    lbTotalItens: TLabel;
    Layout3: TLayout;
    Rectangle4: TRectangle;
    Layout2: TLayout;
    lbTotalGeral: TLabel;
    Label3: TLabel;
    Layout4: TLayout;
    Label5: TLabel;
    Rectangle5: TRectangle;
    lbTotalDescontos: TLabel;
    TabControl_Promocao: TTabControl;
    TabPromocao01: TTabItem;
    TabPromocao02: TTabItem;
    Image3: TImage;
    LayEsquerda: TLayout;
    LayDireita: TLayout;
    Image4: TImage;
    Image5: TImage;
    Image2: TImage;
    procedure Tab02_LanchesClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Tab03_CarrinhoClick(Sender: TObject);
    procedure LayDireitaClick(Sender: TObject);
    procedure LayEsquerdaClick(Sender: TObject);
    procedure TabPromocao02Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Rectangle3Click(Sender: TObject);
  private
    { Private declarations }
    FIdPedido: Integer;
    procedure GetProdutosBase;
    procedure GetProdutosBaseCarrinho;
    procedure AtualizaTotalCarrinho;
    procedure CriarListaDinamicaProdutos(const aProdutoId: Integer; aProdutoNome,
      aProdutoDescricao: String; aProdutoValor: Currency; aScrollBox: TVertScrollBox);
    procedure LimparScrollBox(AScroll: TVertScrollBox);
    procedure RemoveItemEscolhido(Sender: TObject);
    procedure AdicionaItemEscolhido(Sender: TObject);
    function GetIdPedido: Integer;
    function GetQtdeProdutoCarrinho(aIdPedido, aIdProduto: integer): Currency;
  public
    { Public declarations }
  end;

var
  fPrincipal: TfPrincipal;

implementation

uses
  System.SysUtils, FireDAC.Comp.Client;

{$R *.fmx}

{ TfPrincipal }

procedure TfPrincipal.AdicionaItemEscolhido(Sender: TObject);
var
  vQrPedido, vQrPedidoItem: TFDQuery;
begin
  vQrPedido := TFDQuery.Create(nil);
  vQrPedidoItem := TFDQuery.Create(nil);
  try
    dm.QueryProduto.Locate('id', TButtonLabel(Sender).TagString,[]);

    vQrPedido.Connection := dm.FDConnection;
    vQrPedido.Close;
    vQrPedido.SQL.Add('Select * from pedido where idpessoa = :idpessoa and statusPedido = ''A'' ');
    vQrPedido.ParamByName('idpessoa').AsInteger := dm.idPessoaLogada;
    vQrPedido.Open;
    if vQrPedido.IsEmpty then
    begin // executa quando não existe registro do pedido no banco.
      dm.QueryPedido.Close;
      dm.QueryPedido.Open;
      dm.QueryPedido.Append;
      dm.QueryPedidoidpessoa.AsInteger    := dm.idPessoaLogada;
      dm.QueryPedidodatahora.AsDateTime   := now;
      dm.QueryPedidovlrPedido.AsFloat     := dm.QueryProdutovalor.AsCurrency;
      dm.QueryPedidostatusPedido.AsString := 'A';
      dm.QueryPedido.Post;

      dm.QueryPedido.Close;
      dm.QueryPedido.Open;
      dm.QueryPedidoItem.Append;
      dm.QueryPedidoItemIdPedido.AsInteger    := GetIdPedido;
      dm.QueryPedidoItemIdProduto.AsInteger   := dm.QueryProdutoid.AsInteger;
      dm.QueryPedidoItemQtdeProduto.AsInteger := StrToInt(TButtonLabel(Sender).lbTotal.Text)+1;
      dm.QueryPedidoItemVlrItem.AsFloat       := dm.QueryProdutovalor.AsCurrency;
      dm.QueryPedidoItem.Post;
    end else
    begin // executa quando já existe registro do pedido no banco.
      vQrPedidoItem.Connection := dm.FDConnection;
      vQrPedidoItem.Close;
      vQrPedidoItem.SQL.Add('Select * from itempedido where idpedido = :idpedido and idproduto = :idproduto ');
      vQrPedidoItem.ParamByName('idpedido').AsInteger  := vQrPedido.FieldByName('id').AsInteger;
      vQrPedidoItem.ParamByName('idproduto').AsInteger := StrToInt(TButtonLabel(Sender).TagString);
      vQrPedidoItem.Open();

      if vQrPedidoItem.IsEmpty then
      begin // executa se não existir registro do produto no banco.
        dm.QueryPedidoItem.Append;
        dm.QueryPedidoItemIdPedido.AsInteger    := vQrPedido.FieldbyName('id').AsInteger;
        dm.QueryPedidoItemIdProduto.AsInteger   := StrToInt(TButtonLabel(Sender).TagString);
        dm.QueryPedidoItemQtdeProduto.AsInteger := StrToInt(TButtonLabel(Sender).lbTotal.Text)+1;
        dm.QueryPedidoItemVlrItem.AsFloat       := dm.QueryProdutovalor.AsCurrency;
        dm.QueryPedidoItem.Post;

        vQrPedido.Edit;
        vQrPedido.FieldByName('vlrPedido').AsCurrency := vQrPedido.FieldByName('vlrPedido').AsCurrency + dm.QueryProdutovalor.AsCurrency;
        vQrPedido.Post;
      end else
      begin // executa se já existir registro do produto no banco.
        vQrPedidoItem.Edit;
        vQrPedidoItem.FieldByName('qtdeProduto').AsInteger := StrToInt(TButtonLabel(Sender).lbTotal.Text)+1;
        vQrPedidoItem.Post;

        vQrPedido.Edit;
        vQrPedido.FieldByName('vlrPedido').AsCurrency := vQrPedido.FieldByName('vlrPedido').AsCurrency + dm.QueryProdutovalor.AsCurrency;
        vQrPedido.Post;
      end;
    end;
  finally
    FreeAndNil(vQrPedido);
    FreeAndNil(vQrPedidoItem);
    TButtonLabel(Sender).lbTotal.Text := (StrToInt(TButtonLabel(Sender).lbTotal.Text )+1).ToString;
    AtualizaTotalCarrinho;
  end;
end;

procedure TfPrincipal.AtualizaTotalCarrinho;
const cSQL =
      'select                                                   ' +
      '  Coalesce(sum(i.qtdeProduto * i.vlrItem),0) as vlrTotal ' +
      'from pedido pd                                           ' +
      'join itempedido i on pd.id = i.idpedido                  ' +
      'where                                                    ' +
      '  pd.idpessoa = :idpessoa and                            ' +
      '  pd.statusPedido = ''A''                                ' +
      'order by i.idproduto desc                                ';
var
  vQuery: TFDQuery;
begin
  vQuery := TFDQuery.Create(nil);
  try
    vQuery.Connection := dm.FDConnection;
    vQuery.SQL.Add(cSQL);
    vQuery.ParamByName('idpessoa').AsInteger := dm.idPessoaLogada;
    vQuery.Open;
    if vQuery.IsEmpty then
    begin
      lbTotalItens.Text := '0.00';
      lbTotalGeral.Text := '0.00';
    end
    else begin
      lbTotalItens.Text := 'R$ ' + FormatFloat('##,0.00',vQuery.FieldByName('vlrTotal').AsCurrency);
      lbTotalGeral.Text := 'R$ ' + FormatFloat('##,0.00',vQuery.FieldByName('vlrTotal').AsCurrency);
    end;
  finally
    FreeAndNil(vQuery);
  end;
end;

procedure TfPrincipal.CriarListaDinamicaProdutos(const aProdutoId: Integer;
  aProdutoNome, aProdutoDescricao: String; aProdutoValor: Currency; aScrollBox: TVertScrollBox);
var
  RectFundo, RectBarraInferior, rect: TRecTangle;
  lbProdutoNome, lbProdutoDescricao, lbQtde, lbPreco: TLabel;
  imgLanche: TImage;
  layPreco, layInteracoes: TLayout;
  btDelete, btAdicionar: TButtonLabel;
begin
  //Criando o retangulo de fundo do item
  RectFundo := TRectangle.Create(aScrollBox);
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
    Text := 'R$ ' + FormatFloat('##,0.00',aProdutoValor);
    Margins.Left := 5;
    Margins.Right := 5;
    name := 'lbPreco' + IntToStr(aProdutoId);
    TagString := 'lbPreco' + IntToStr(aProdutoId);
    Align := TAlignLayout.Client;
  end;

  //Cria Layout para adionar botões de ação.
  layInteracoes := TLayout.Create(RectFundo);
  with layInteracoes do
  begin
    RectFundo.AddObject(layInteracoes);
    Align := TAlignLayout.Right;
    Width := 120;
    Fill.Color := TAlphacolors.Dimgray;
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
    Margins.Left := 5;
    Margins.Right := 5;
    name := 'lbTotal' + IntToStr(aProdutoId);
    Align := TAlignLayout.Client;

    if (GetQtdeProdutoCarrinho(GetIdPedido, aProdutoId) > 0) then
      Text := CurrToStr(GetQtdeProdutoCarrinho(GetIdPedido, aProdutoId))
    else
      Text := '0';
  end;

  //Cria botão para adicionar.
  btAdicionar := TButtonLabel.Create(layInteracoes);
  with btAdicionar do
  begin
    layInteracoes.AddObject(btAdicionar);
    StyleLookup := 'AddItemButton';
    TagString := IntToStr(aProdutoId);
    Height := 40;
    Width := 40;
    OnClick := AdicionaItemEscolhido;
    Align := TAlignLayout.Right;
    lbTotal := lbQtde;
  end;

  //Cria botão para remover.
  btDelete := TButtonLabel.Create(layInteracoes);
  with btDelete do
  begin
    layInteracoes.AddObject(btDelete);
    StyleLookup := 'DeleteItemButton';
    TagString := IntToStr(aProdutoId);
    Height := 40;
    Width := 40;
    OnClick := RemoveItemEscolhido;
    Align := TAlignLayout.Left;
    lbTotal := lbQtde;
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

  aScrollBox.AddObject(RectFundo);
end;

procedure TfPrincipal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Close();
  FAcesso.Close;
end;

procedure TfPrincipal.FormCreate(Sender: TObject);
begin
  TabControl.ActiveTab := Tab01_Promocoes;
  TabControl_Promocao.ActiveTab := TabPromocao01;
  LayEsquerda.Visible := False;
end;

function TfPrincipal.GetIdPedido: Integer;
var
  vQuery: TFDQuery;
begin
  vQuery := TFDQuery.Create(nil);
  try
    vQuery.Connection := dm.FDConnection;
    vQuery.SQL.Add('select * from pedido where idpessoa = :idpessoa and statuspedido = ''A'' ');
    vQuery.ParamByName('idpessoa').AsInteger := dm.idPessoaLogada;
    vQuery.Open;

    if vQuery.IsEmpty then
      Result := 0
    else
      Result := vQuery.FieldByName('id').AsInteger;
  finally
    FreeAndNil(vQuery);
  end;
end;

procedure TfPrincipal.GetProdutosBase;
begin
  LimparScrollBox(Tab02_ScrollBox);

  dm.QueryProduto.Close;
  dm.QueryProduto.Open();

  dm.QueryProduto.First;
  while not dm.QueryProduto.Eof do
  begin
    CriarListaDinamicaProdutos(dm.QueryProdutoid.AsInteger,
                               dm.QueryProdutoNome.AsString,
                               dm.QueryProdutoDescricao.AsString,
                               dm.QueryProdutoValor.AsCurrency,
                               Tab02_ScrollBox);

    dm.QueryProduto.Next;
  end;
end;

procedure TfPrincipal.GetProdutosBaseCarrinho;
const cSQL =
      'select                                    ' +
      '  i.idpedido, i.idproduto, i.qtdeproduto, ' +
      '  p.nome, p.descricao, p.valor            ' +
      'from pedido pd                            ' +
      '  join itempedido i on pd.id = i.idpedido ' +
      '  join produto p on i.idProduto = p.id    ' +
      'where                                     ' +
      '  pd.idpessoa = :idpessoa                 ' +
      '  and pd.statusPedido = ''A''             ' +
      'order by idproduto desc                   ';
var
  vQuery: TFDQuery;
begin
  LimparScrollBox(Tab03_ScrollBox);

  vQuery := TFDQuery.Create(nil);
  try
    vQuery.Connection := dm.FDConnection;
    vQuery.SQL.Add(cSQL);
    vQuery.ParamByName('idpessoa').AsInteger := dm.idPessoaLogada;
    vQuery.Open;
    if not vQuery.IsEmpty then
    begin
      vQuery.First;
      while not vQuery.Eof do
      begin
        CriarListaDinamicaProdutos(vQuery.FieldByName('idProduto').AsInteger,
                                   vQuery.FieldByName('nome').AsString,
                                   vQuery.FieldByName('descricao').AsString,
                                   vQuery.FieldByName('valor').AsCurrency,
                                   Tab03_ScrollBox);
        vQuery.Next;
      end;
    end
  finally
    FreeAndNil(vQuery);
    AtualizaTotalCarrinho;
  end;
end;

function TfPrincipal.GetQtdeProdutoCarrinho(aIdPedido,
  aIdProduto: integer): Currency;
var
  vQuery: TFDQuery;
begin
  vQuery := TFDQuery.Create(nil);
  try
    vQuery.Connection := dm.FDConnection;
    vQuery.SQL.Add('Select qtdeproduto from itempedido where idpedido = :idpedido and idproduto = :idproduto');
    vQuery.ParamByName('idproduto').AsInteger := aIdProduto;
    vQuery.ParamByName('idPedido').AsInteger := aIdPedido;
    vQuery.Open();

    if vQuery.IsEmpty then
      Result := 0
    else
      Result := vQuery.FieldByName('qtdeproduto').AsInteger;
  finally
    FreeAndNil(vQuery);
  end;
end;

procedure TfPrincipal.LayDireitaClick(Sender: TObject);
begin
  TabControl_Promocao.ActiveTab := TabPromocao02;
  LayDireita.Visible := False;
  LayEsquerda.Visible := True;
end;

procedure TfPrincipal.LayEsquerdaClick(Sender: TObject);
begin
  TabControl_Promocao.ActiveTab := TabPromocao01;
  LayDireita.Visible := True;
  LayEsquerda.Visible := False;
end;

procedure TfPrincipal.LimparScrollBox(AScroll: TVertScrollBox);
var i: integer;
begin
  for i := AScroll.ComponentCount-1 downto 0 do
      if AScroll.Components[i] is TRectangle then
         TButton(AScroll.Components[i]).DisposeOf;
end;

procedure TfPrincipal.Rectangle3Click(Sender: TObject);
var
  vQrPedido: TFDQuery;
begin
  vQrPedido := TFDQuery.Create(nil);
  try
    vQrPedido.Connection := dm.FDConnection;
    vQrPedido.SQL.Add('Select * from pedido where idpessoa = :idpessoa and statusPedido = ''A'' ');
    vQrPedido.ParamByName('idpessoa').AsInteger := dm.idPessoaLogada;
    vQrPedido.Open;
    if not vQrPedido.IsEmpty then
    begin
      vQrPedido.Edit;
      vQrPedido.FieldByName('statuspedido').AsString := 'F';
      vQrPedido.Post;

      ShowMessage('Pedido registrado com sucesso!');
    end else
    begin
      ShowMessage('Houve um erro ao gravar o pedido!');
    end;
  finally
    FreeAndNil(vQrPedido);
    GetProdutosBase;
    GetProdutosBaseCarrinho;
  end;
end;

procedure TfPrincipal.RemoveItemEscolhido(Sender: TObject);
var
  vQrPedido, vQrPedidoItem: TFDQuery;
begin
  if (StrToInt(TButtonLabel(Sender).lbTotal.Text) <= 0) then
    Exit;

  vQrPedido := TFDQuery.Create(nil);
  vQrPedidoItem := TFDQuery.Create(nil);
  try
    vQrPedido.Connection := dm.FDConnection;
    vQrPedido.Close;
    vQrPedido.SQL.Add('Select * from pedido where idpessoa = :idpessoa and statusPedido = ''A'' ');
    vQrPedido.ParamByName('idpessoa').AsInteger := dm.idPessoaLogada;

    vQrPedido.Open;
    if not vQrPedido.IsEmpty then
    begin // executa somente se existir o registro do pedido no banco.
      vQrPedidoItem.Connection := dm.FDConnection;
      vQrPedidoItem.Close;
      vQrPedidoItem.SQL.Add('Select * from itempedido where idpedido = :idpedido and idproduto = :idproduto ');
      vQrPedidoItem.ParamByName('idpedido').AsInteger := vQrPedido.FieldByName('id').AsInteger;
      vQrPedidoItem.ParamByName('idproduto').AsInteger := StrToInt(TButtonLabel(Sender).TagString);
      vQrPedidoItem.Open();

      if not vQrPedidoItem.IsEmpty then
      begin // executa somente se existir o registro do produto no banco.
        if (vQrPedidoItem.FieldByName('qtdeProduto').AsInteger = 1) then
        begin
          vQrPedido.Edit;
          vQrPedido.FieldByName('vlrPedido').AsCurrency :=  vQrPedido.FieldByName('vlrPedido').AsCurrency - vQrPedidoItem.FieldByName('vlrItem').AsCurrency;
          vQrPedido.Post;

          vQrPedidoItem.Delete;
        end else
        begin
          vQrPedido.Edit;
          vQrPedido.FieldByName('vlrPedido').AsCurrency :=  vQrPedido.FieldByName('vlrPedido').AsCurrency - vQrPedidoItem.FieldByName('vlrItem').AsCurrency;
          vQrPedido.Post;

          vQrPedidoItem.Edit;
          vQrPedidoItem.FieldByName('qtdeProduto').AsInteger := StrToInt(TButtonLabel(Sender).lbTotal.Text)-1;
          vQrPedidoItem.Post;
        end;
      end;
    end;
  finally
    FreeAndNil(vQrPedido);
    FreeAndNil(vQrPedidoItem);
    TButtonLabel(Sender).lbTotal.Text := (StrToInt(TButtonLabel(Sender).lbTotal.Text )-1).ToString;
    AtualizaTotalCarrinho;
  end;

  if TabControl.ActiveTab = Tab03_Carrinho then
    GetProdutosBaseCarrinho;
end;

procedure TfPrincipal.Tab02_LanchesClick(Sender: TObject);
begin
  GetProdutosBase;
end;

procedure TfPrincipal.Tab03_CarrinhoClick(Sender: TObject);
begin
  GetProdutosBaseCarrinho;
end;

procedure TfPrincipal.TabPromocao02Click(Sender: TObject);
begin

end;

{ TButtonLabel }

constructor TButtonLabel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

end.
