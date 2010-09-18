object fIOError: TfIOError
  Left = 482
  Top = 597
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  ClientHeight = 135
  ClientWidth = 439
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnKeyDown = FormKeyDown
  OnKeyUp = FormKeyUp
  OnMouseMove = FormMouseMove
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 8
    Top = 4
    Width = 145
    Height = 93
  end
  object Image: TImage
    Left = 160
    Top = 8
    Width = 32
    Height = 32
    Transparent = True
    OnMouseMove = FormMouseMove
  end
  object Label1: TDLabel
    Left = 96
    Top = 32
    Width = 16
    Height = 19
    AlphaBlend = False
    AlphaBlendValue = 0
    AutoSize = False
    Alignment = taCenter
    Caption = '/'
    BackEffect = ef00
    FontShadow = 1
    Displ.Enabled = False
    Displ.Format = '88'
    Displ.SizeX = 4
    Displ.SizeY = 4
    Displ.SpaceSX = 2
    Displ.SpaceSY = 2
    Displ.SizeT = 1
    Displ.Spacing = 0
    Displ.ColorA = clRed
    Displ.ColorD = clMaroon
    Displ.Size = 0
    BevelOuter = bvNone
    Layout = tlCenter
    Transparent = True
    TransparentColor = False
    TransparentColorValue = clBlack
    WordWrap = False
    OnMouseMove = FormMouseMove
  end
  object PanelCount: TDLabel
    Left = 112
    Top = 32
    Width = 33
    Height = 19
    AlphaBlend = False
    AlphaBlendValue = 0
    AutoSize = False
    Alignment = taRightJustify
    Caption = '9,999'
    FontShadow = 1
    Displ.Enabled = False
    Displ.Format = '88'
    Displ.SizeX = 4
    Displ.SizeY = 4
    Displ.SpaceSX = 2
    Displ.SpaceSY = 2
    Displ.SizeT = 1
    Displ.Spacing = 0
    Displ.ColorA = clRed
    Displ.ColorD = clMaroon
    Displ.Size = 0
    BevelOuter = bvNone
    BorderStyle = bsSingle
    Layout = tlCenter
    Transparent = False
    TransparentColor = False
    TransparentColorValue = clBlack
    WordWrap = False
    OnMouseMove = FormMouseMove
  end
  object LabelTimeLeft: TDLabel
    Left = 200
    Top = 8
    Width = 73
    Height = 17
    AlphaBlend = False
    AlphaBlendValue = 0
    AutoSize = False
    Alignment = taLeftJustify
    Caption = 'Time to Close:'
    BackEffect = ef08
    FontShadow = 1
    Displ.Enabled = False
    Displ.Format = '88'
    Displ.SizeX = 4
    Displ.SizeY = 4
    Displ.SpaceSX = 2
    Displ.SpaceSY = 2
    Displ.SizeT = 1
    Displ.Spacing = 0
    Displ.ColorA = clRed
    Displ.ColorD = clMaroon
    Displ.Size = 0
    BevelOuter = bvLowered
    Layout = tlCenter
    Transparent = True
    TransparentColor = False
    TransparentColorValue = clBlack
    WordWrap = False
    OnClick = LabelTimeLeftClick
    OnMouseMove = FormMouseMove
  end
  object PanelTimeLeft: TDLabel
    Left = 200
    Top = 24
    Width = 73
    Height = 17
    AlphaBlend = False
    AlphaBlendValue = 0
    AutoSize = False
    Alignment = taRightJustify
    Displ.Enabled = False
    Displ.Format = '88'
    Displ.SizeX = 4
    Displ.SizeY = 4
    Displ.SpaceSX = 2
    Displ.SpaceSY = 2
    Displ.SizeT = 1
    Displ.Spacing = 0
    Displ.ColorA = clRed
    Displ.ColorD = clMaroon
    Displ.Size = 0
    BevelOuter = bvLowered
    Layout = tlCenter
    Transparent = False
    TransparentColor = False
    TransparentColorValue = clBlack
    WordWrap = False
    OnClick = LabelTimeLeftClick
    OnMouseMove = FormMouseMove
  end
  object LabelCreated: TDLabel
    Left = 280
    Top = 8
    Width = 153
    Height = 17
    AlphaBlend = False
    AlphaBlendValue = 0
    AutoSize = False
    Alignment = taLeftJustify
    Caption = 'Created:'
    BackEffect = ef08
    FontShadow = 1
    Displ.Enabled = False
    Displ.Format = '88'
    Displ.SizeX = 4
    Displ.SizeY = 4
    Displ.SpaceSX = 2
    Displ.SpaceSY = 2
    Displ.SizeT = 1
    Displ.Spacing = 0
    Displ.ColorA = clRed
    Displ.ColorD = clMaroon
    Displ.Size = 0
    BevelOuter = bvLowered
    Layout = tlCenter
    Transparent = True
    TransparentColor = False
    TransparentColorValue = clBlack
    WordWrap = False
    OnMouseMove = FormMouseMove
  end
  object PanelCreated: TDLabel
    Left = 280
    Top = 24
    Width = 153
    Height = 17
    AlphaBlend = False
    AlphaBlendValue = 0
    AutoSize = False
    Alignment = taRightJustify
    Displ.Enabled = False
    Displ.Format = '88'
    Displ.SizeX = 4
    Displ.SizeY = 4
    Displ.SpaceSX = 2
    Displ.SpaceSY = 2
    Displ.SizeT = 1
    Displ.Spacing = 0
    Displ.ColorA = clRed
    Displ.ColorD = clMaroon
    Displ.Size = 0
    BevelOuter = bvLowered
    Layout = tlCenter
    Transparent = False
    TransparentColor = False
    TransparentColorValue = clBlack
    WordWrap = False
    OnMouseMove = FormMouseMove
  end
  object LabelMessage: TDLabel
    Left = 16
    Top = 8
    Width = 129
    Height = 19
    AlphaBlend = False
    AlphaBlendValue = 0
    AutoSize = False
    Alignment = taLeftJustify
    Caption = 'Message'
    BackEffect = ef08
    FontShadow = 1
    Displ.Enabled = False
    Displ.Format = '88'
    Displ.SizeX = 4
    Displ.SizeY = 4
    Displ.SpaceSX = 2
    Displ.SpaceSY = 2
    Displ.SizeT = 1
    Displ.Spacing = 0
    Displ.ColorA = clRed
    Displ.ColorD = clMaroon
    Displ.Size = 0
    BevelOuter = bvLowered
    Layout = tlCenter
    Transparent = True
    TransparentColor = False
    TransparentColorValue = clBlack
    WordWrap = False
    OnMouseMove = FormMouseMove
  end
  object ButtonRetry: TDButton
    Left = 256
    Top = 104
    Width = 81
    Height = 23
    Caption = '&Retry'
    Default = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBtnText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnClick = ButtonRetryClick
    OnKeyDown = FormKeyDown
    OnKeyUp = FormKeyUp
    OnMouseMove = FormMouseMove
  end
  object ButtonIgnore: TDButton
    Left = 160
    Top = 104
    Width = 81
    Height = 23
    Cancel = True
    Caption = '&Ignore'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBtnText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = ButtonIgnoreClick
    OnKeyDown = FormKeyDown
    OnKeyUp = FormKeyUp
    OnMouseMove = FormMouseMove
  end
  object ButtonIgnoreAll: TDButton
    Left = 400
    Top = 0
    Width = 81
    Height = 23
    Caption = 'Ignore &All'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBtnText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    Visible = False
    OnClick = ButtonIgnoreAllClick
    OnKeyDown = FormKeyDown
    OnKeyUp = FormKeyUp
    OnMouseMove = FormMouseMove
  end
  object ButtonExit: TDButton
    Left = 16
    Top = 64
    Width = 129
    Height = 23
    Caption = '&Close Program'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBtnText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    OnClick = ButtonExitClick
    OnKeyDown = FormKeyDown
    OnKeyUp = FormKeyUp
    OnMouseMove = FormMouseMove
  end
  object ButtonOpen: TDButton
    Left = 352
    Top = 104
    Width = 81
    Height = 23
    Caption = '&File...'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBtnText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    OnClick = ButtonOpenClick
    OnKeyDown = FormKeyDown
    OnKeyUp = FormKeyUp
    OnMouseMove = FormMouseMove
  end
  object MemoMsg: TMemo
    Left = 160
    Top = 48
    Width = 273
    Height = 45
    Color = clBtnFace
    Lines.Strings = (
      '1'
      '2'
      '3')
    ReadOnly = True
    TabOrder = 5
    WordWrap = False
    OnKeyDown = FormKeyDown
    OnKeyUp = FormKeyUp
    OnMouseMove = FormMouseMove
  end
  object ButtonAll: TDButton
    Left = 8
    Top = 103
    Width = 145
    Height = 23
    Caption = 'Use Answer for All'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBtnText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 6
    OnKeyDown = FormKeyDown
    OnKeyUp = FormKeyUp
    OnMouseMove = FormMouseMove
    AutoChange = True
  end
  object ButtonDown: TDButton
    Left = 16
    Top = 32
    Width = 19
    Height = 19
    Caption = 'Left'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBtnText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 7
    OnClick = ButtonDownClick
    OnMouseMove = FormMouseMove
  end
  object EditIndex: TDEdit
    Left = 40
    Top = 32
    Width = 37
    Height = 19
    Style = csSimple
    ItemHeight = 13
    TabOrder = 8
    Text = '9,999'
    OnChange = EditIndexChange
    Readonly = False
    Modified = False
    SelStart = 0
    SelLength = 0
    OnMouseMove = FormMouseMove
    Caption = 'Caption'
    LabelPosition = lpAbove
    ShowCaption = False
    SelectOnClick = True
  end
  object ButtonUp: TDButton
    Tag = 1
    Left = 80
    Top = 32
    Width = 19
    Height = 19
    Caption = 'Right'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBtnText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 9
    OnClick = ButtonDownClick
    OnMouseMove = FormMouseMove
  end
  object OpenDialogFile: TOpenDialog
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofCreatePrompt, ofEnableSizing]
    Title = 'Select file'
    Left = 472
    Top = 144
  end
  object Timer1: TDTimer
    ActiveOnly = True
    Enabled = False
    Interval = 1000
    EventStep = esInterval
    OnTimer = Timer1Timer
    Left = 8
    Top = 88
  end
end
