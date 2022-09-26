object Dm: TDm
  OldCreateOrder = False
  Height = 142
  Width = 518
  object FDConnection: TFDConnection
    Params.Strings = (
      
        'Database=C:\Users\F'#225'bio\Documents\Embarcadero\Studio\Projects\Ap' +
        'pDogaoNew\DataBase\DogaoDB.db'
      'SharedCache=10000'
      'LockingMode=Normal'
      'DriverID=SQLite')
    Connected = True
    LoginPrompt = False
    AfterConnect = FDConnectionAfterConnect
    BeforeConnect = FDConnectionBeforeConnect
    Left = 32
    Top = 16
  end
  object QueryPessoa: TFDQuery
    Connection = FDConnection
    SQL.Strings = (
      'select'
      '  *'
      'from pessoa'
      ''
      '')
    Left = 104
    Top = 16
    object QueryPessoaid: TFDAutoIncField
      FieldName = 'id'
      Origin = 'id'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object QueryPessoanome: TStringField
      FieldName = 'nome'
      Origin = 'nome'
      Size = 40
    end
    object QueryPessoacpf: TStringField
      FieldName = 'cpf'
      Origin = 'cpf'
      Size = 11
    end
    object QueryPessoacelular: TStringField
      FieldName = 'celular'
      Origin = 'celular'
      Size = 13
    end
    object QueryPessoacep: TStringField
      FieldName = 'cep'
      Origin = 'cep'
      Size = 10
    end
    object QueryPessoaendereco: TStringField
      FieldName = 'endereco'
      Origin = 'endereco'
      Size = 60
    end
    object QueryPessoacidade: TStringField
      FieldName = 'cidade'
      Origin = 'cidade'
      Size = 60
    end
    object QueryPessoauf: TStringField
      FieldName = 'uf'
      Origin = 'uf'
      FixedChar = True
      Size = 2
    end
    object QueryPessoabairro: TStringField
      FieldName = 'bairro'
      Origin = 'bairro'
      Size = 60
    end
    object QueryPessoaemail: TStringField
      FieldName = 'email'
      Origin = 'email'
      Size = 60
    end
    object QueryPessoasenha: TStringField
      FieldName = 'senha'
      Origin = 'senha'
      Size = 40
    end
    object QueryPessoaimg_usuario: TBlobField
      FieldName = 'img_usuario'
      Origin = 'img_usuario'
    end
  end
  object QueryProduto: TFDQuery
    Connection = FDConnection
    SQL.Strings = (
      'select'
      '  *'
      'from produto'
      'order by id desc'
      '')
    Left = 176
    Top = 16
    object QueryProdutoid: TFDAutoIncField
      FieldName = 'id'
      Origin = 'id'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object QueryProdutonome: TStringField
      FieldName = 'nome'
      Origin = 'nome'
    end
    object QueryProdutodescricao: TStringField
      FieldName = 'descricao'
      Origin = 'descricao'
      Size = 200
    end
    object QueryProdutovalor: TBCDField
      FieldName = 'valor'
      Origin = 'valor'
      Precision = 14
      Size = 2
    end
    object QueryProdutoquantidade: TIntegerField
      FieldName = 'quantidade'
      Origin = 'quantidade'
    end
    object QueryProdutoimg_produto: TBlobField
      FieldName = 'img_produto'
      Origin = 'img_produto'
    end
  end
  object QueryPedido: TFDQuery
    Active = True
    Connection = FDConnection
    SQL.Strings = (
      'select'
      '  *'
      'from pedido'
      '')
    Left = 248
    Top = 16
    object QueryPedidoid: TIntegerField
      FieldName = 'id'
      Origin = 'id'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object QueryPedidoidpessoa: TIntegerField
      FieldName = 'idpessoa'
      Origin = 'idpessoa'
    end
    object QueryPedidodatahora: TDateTimeField
      FieldName = 'datahora'
      Origin = 'datahora'
    end
    object QueryPedidovlrPedido: TBCDField
      FieldName = 'vlrPedido'
      Origin = 'vlrPedido'
      Precision = 8
      Size = 2
    end
    object QueryPedidostatusPedido: TStringField
      FieldName = 'statusPedido'
      Origin = 'statusPedido'
      FixedChar = True
      Size = 1
    end
  end
  object QueryPedidoItem: TFDQuery
    Active = True
    Connection = FDConnection
    SQL.Strings = (
      'select'
      '  *'
      'from itempedido'
      '')
    Left = 328
    Top = 16
    object QueryPedidoItemid: TIntegerField
      FieldName = 'id'
      Origin = 'id'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object QueryPedidoItemidPedido: TIntegerField
      FieldName = 'idPedido'
      Origin = 'idPedido'
    end
    object QueryPedidoItemidProduto: TIntegerField
      FieldName = 'idProduto'
      Origin = 'idProduto'
    end
    object QueryPedidoItemqtdeProduto: TIntegerField
      FieldName = 'qtdeProduto'
      Origin = 'qtdeProduto'
    end
    object QueryPedidoItemvlrItem: TBCDField
      FieldName = 'vlrItem'
      Origin = 'vlrItem'
      Precision = 8
      Size = 2
    end
  end
end
