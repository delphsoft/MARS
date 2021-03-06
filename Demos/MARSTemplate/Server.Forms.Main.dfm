object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'MARS-Curiosity Template Server'
  ClientHeight = 201
  ClientWidth = 464
  Color = clBtnFace
  Constraints.MinHeight = 240
  Constraints.MinWidth = 480
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object TopPanel: TPanel
    Left = 0
    Top = 0
    Width = 464
    Height = 73
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object StatusLabel: TLabel
      Left = 24
      Top = 48
      Width = 56
      Height = 13
      Caption = 'StatusLabel'
    end
    object StartButton: TButton
      Left = 24
      Top = 9
      Width = 75
      Height = 25
      Action = StartServerAction
      TabOrder = 0
    end
    object StopButton: TButton
      Left = 112
      Top = 9
      Width = 75
      Height = 25
      Action = StopServerAction
      TabOrder = 1
    end
  end
  object MainActionList: TActionList
    Left = 384
    Top = 24
    object StartServerAction: TAction
      Caption = 'Start Server'
      OnExecute = StartServerActionExecute
      OnUpdate = StartServerActionUpdate
    end
    object StopServerAction: TAction
      Caption = 'Stop Server'
      OnExecute = StopServerActionExecute
      OnUpdate = StopServerActionUpdate
    end
  end
end
