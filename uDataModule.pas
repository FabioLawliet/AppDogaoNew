unit uDataModule;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.FMXUI.Wait, Data.DB,
  FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Comp.DataSet, IOUtils;

type
  TDm = class(TDataModule)
    FDConnection: TFDConnection;
    QueryPessoa: TFDQuery;
    QueryPessoaid: TFDAutoIncField;
    QueryPessoanome: TStringField;
    QueryPessoacpf: TStringField;
    QueryPessoacelular: TStringField;
    QueryPessoacep: TStringField;
    QueryPessoaendereco: TStringField;
    QueryPessoacidade: TStringField;
    QueryPessoauf: TStringField;
    QueryPessoabairro: TStringField;
    QueryPessoaemail: TStringField;
    QueryPessoasenha: TStringField;
    QueryPessoaimg_usuario: TBlobField;
    QueryProduto: TFDQuery;
    QueryProdutoid: TFDAutoIncField;
    QueryProdutonome: TStringField;
    QueryProdutodescricao: TStringField;
    QueryProdutovalor: TBCDField;
    QueryProdutoquantidade: TIntegerField;
    QueryProdutoimg_produto: TBlobField;
    QueryPedido: TFDQuery;
    QueryPedidoItem: TFDQuery;
    QueryPedidoid: TIntegerField;
    QueryPedidoidpessoa: TIntegerField;
    QueryPedidodatahora: TDateTimeField;
    QueryPedidovlrPedido: TBCDField;
    QueryPedidostatusPedido: TStringField;
    QueryPedidoItemid: TIntegerField;
    QueryPedidoItemidPedido: TIntegerField;
    QueryPedidoItemidProduto: TIntegerField;
    QueryPedidoItemqtdeProduto: TIntegerField;
    QueryPedidoItemvlrItem: TBCDField;
    procedure FDConnectionAfterConnect(Sender: TObject);
    procedure FDConnectionBeforeConnect(Sender: TObject);
  private
    FIdPessoa: Integer;
    { Private declarations }
  public
    { Public declarations }
    property idPessoaLogada: Integer read FIdPessoa write FIdPessoa;
  end;

var
  Dm: TDm;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

procedure TDm.FDConnectionAfterConnect(Sender: TObject);
const
  cSQLCreatePessoa =
  'create table IF NOT EXISTS pessoa( 	    	    ' +
  'id integer not null primary key autoincrement, ' +
  'nome varchar(40),                              ' +
  'cpf varchar(11),                               ' +
  'celular varchar(13),                           ' +
  'cep varchar(10),                               ' +
  'endereco varchar(60),                          ' +
  'cidade varchar(60),                            ' +
  'uf char(2),                                    ' +
  'bairro varchar(60),                            ' +
  'email varchar(60),                             ' +
  'senha varchar(40),                             ' +
  'img_usuario blob)                              ';

  cSQLCreateProduto =
  ' create table IF NOT EXISTS produto(            ' +
  ' id integer not null primary key autoincrement, ' +
  ' nome varchar(20),                              ' +
  ' descricao varchar(200),                        ' +
  ' valor numeric(14,2),                           ' +
  ' quantidade integer,                            ' +
  ' img_produto blob)                              ';

  cSQLInsertProdutos =
  'insert or replace into produto values(1,''Dogao'',''Duas salsichas, alface, tomate, queijo, bacon, maionese, ketchup, batata palha.'', 18.90, 100, null), ' +
  '(2,''X Burguer'',''Hamburguer artesanal, cebola caramelizada, queijo mussarela, bacon, molho especial.'', 24.50, 100, null), ' +
  '(3,''X Salada'',''Hamburguer artesanal, alface, tomate, queijo mussarela.'', 22.50, 100, null), ' +
  '(4,''X Bacon'',''Hamburguer artesanal, bastante bacon, cebola caramelizada, alface, tomate, queijo mussarela, molho especial.'', 29.50, 100, null), ' +
  '(5,''X Tudo'',''Hamburguer artesanal, filé de frango, salsicha, ovo, bacon, presunto, queijo mussarela, alface, tomate, molho especial.'', 32.00, 100, null), ' +
  '(6,''X EGG'',''Hamburguer artesanal, ovo, alface, tomate, queijo mussarela.'', 24.50, 100, null), ' +
  '(7,''X Frango'',''Frango desfiado, queijo mussarela, alface, tomate.'', 25.50, 100, null), ' +
  '(8,''X Lombo'',''Lombo canadence, queijo mussarela, bacon, alface, tomate, molho especial.'', 28.50, 100, null), ' +
  '(9,''X Tilápia'',''Tilápia empanada, queijo mussarela, rucula, tomate.'', 29.00, 100, null) ';

  cSQLCreatePedido =
  ' create table IF NOT EXISTS pedido(           ' +
  ' id integer primary key,                      ' +
  ' idpessoa integer,                            ' +
  ' datahora datetime,                           ' +
  ' vlrPedido numeric(8,2),                      ' +
  ' statusPedido char(1),                        ' +
  ' foreign key (idpessoa) references pessoa(id))';

  cSQLCreateItemPedido =
  ' create table IF NOT EXISTS itempedido(          ' +
  ' id integer primary key,                         ' +
  ' idPedido integer,                               ' +
  ' idProduto integer,                              ' +
  ' qtdeProduto integer,                            ' +
  ' vlrItem numeric(8,2),                           ' +
  ' foreign key (idPedido) references pedido(id)    ' +
  ' foreign key (idProduto) references produto(id)) ';
begin
  FDConnection.ExecSQL(cSQLCreatePessoa);
  FDConnection.ExecSQL(cSQLCreateProduto);
  FDConnection.ExecSQL(cSQLInsertProdutos);
  FDConnection.ExecSQL(cSQLCreatePedido);
  FDConnection.ExecSQL(cSQLCreateItemPedido);
end;

procedure TDm.FDConnectionBeforeConnect(Sender: TObject);
var
  strPath: String;
begin
  {$IF DEFINED(iOS) or DEFINED(ANDROID)}
  strPath := System.IOUtils.TPath.Combine(System.IOUtils.TPath.GetDocumentsPath, 'DogaoDB.db');
  {$ENDIF}
  {$IFDEF MSWINDOWS}
  strPath := System.IOUtils.TPath.Combine
    ('C:\Users\Fábio\Documents\Embarcadero\Studio\Projects\AppDogaoNew\DataBase','DogaoDB.db');
  {$ENDIF}
  FDConnection.Params.Values['UseUnicode'] := 'False';
  FDConnection.Params.Values['DataBase'] := strPath;
end;

end.
