VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   3090
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   4680
   LinkTopic       =   "Form1"
   ScaleHeight     =   3090
   ScaleWidth      =   4680
   StartUpPosition =   3  'Windows Default
   Begin VB.TextBox Text1 
      Alignment       =   2  'Center
      BackColor       =   &H00000000&
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   15.75
         Charset         =   178
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FFFFFF&
      Height          =   495
      Left            =   2160
      TabIndex        =   1
      Text            =   "128"
      Top             =   240
      Width           =   1815
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Set Transparency Alpha"
      Height          =   495
      Left            =   240
      TabIndex        =   0
      Top             =   240
      Width           =   1815
   End
   Begin VB.Shape Shape1 
      BorderColor     =   &H000000FF&
      BorderWidth     =   3
      Height          =   495
      Left            =   360
      Shape           =   2  'Oval
      Top             =   1080
      Width           =   1095
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Const GWL_EXSTYLE = (-20)
Private Const WS_EX_LAYERED = &H80000
Private Const LWA_ALPHA = &H2

Private Declare Function GetWindowLong Lib "user32" _
  Alias "GetWindowLongA" (ByVal hWnd As Long, _
  ByVal nIndex As Long) As Long

Private Declare Function SetWindowLong Lib "user32" _
   Alias "SetWindowLongA" (ByVal hWnd As Long, _
   ByVal nIndex As Long, ByVal dwNewLong As Long) _
   As Long

Private Declare Function SetLayeredWindowAttributes Lib _
    "user32" (ByVal hWnd As Long, ByVal crKey As Long, _
    ByVal bAlpha As Byte, ByVal dwFlags As Long) As Long
Private LastAlpha As Long

Public Function TransForm(fhWnd As Long, Alpha As Byte) As Boolean
'Set alpha between 0-255
' 0 = Invisible , 128 = 50% transparent , 255 = Opaque
    SetWindowLong fhWnd, GWL_EXSTYLE, WS_EX_LAYERED
    SetLayeredWindowAttributes fhWnd, 0, Alpha, LWA_ALPHA
    LastAlpha = Alpha
End Function

Private Sub Command1_Click()
    Dim i As Long
    i = CLng(Text1.Text)
    If i < 0 Or i > 255 Then
        MsgBox "Select a number between 1-255", vbCritical
        Exit Sub
    End If
    TransForm Me.hWnd, CByte(i)
End Sub

Private Sub Form_Load()
    TransForm Me.hWnd, 0
    Me.Show
Dim i As Long
    For i = 0 To 255 Step 3
        TransForm Me.hWnd, CByte(i)
        DoEvents
    Next
    TransForm Me.hWnd, 255
End Sub

Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
Dim i As Long
    For i = LastAlpha To 0 Step -3
        TransForm Me.hWnd, CByte(i)
        DoEvents
    Next
End Sub

Private Sub Text1_KeyPress(KeyAscii As Integer)
    If (KeyAscii < 48 Or KeyAscii > 57) And KeyAscii <> 8 Then KeyAscii = 0
End Sub
