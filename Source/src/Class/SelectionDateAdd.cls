VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "SelectionDateAdd"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'-----------------------------------------------------------------------------------------------------
'
' [RelaxTools-Addin] v4
'
' Copyright (c) 2009 Yasuhiro Watanabe
' https://github.com/RelaxTools/RelaxTools-Addin
' author:relaxtools@opensquare.net
'
' The MIT License (MIT)
'
' Permission is hereby granted, free of charge, to any person obtaining a copy
' of this software and associated documentation files (the "Software"), to deal
' in the Software without restriction, including without limitation the rights
' to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
' copies of the Software, and to permit persons to whom the Software is
' furnished to do so, subject to the following conditions:
'
' The above copyright notice and this permission notice shall be included in all
' copies or substantial portions of the Software.
'
' THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
' IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
' FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
' AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
' LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
' OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
' SOFTWARE.
'
'-----------------------------------------------------------------------------------------------------
Option Explicit


Private lngAdd As Long
Private strDate As String


'------------------------------------------------------------------------------------------------------------------------
' SelectionAllFrameWork 宣言
'------------------------------------------------------------------------------------------------------------------------
Private WithEvents SFWork As SelectionAllFrameWork
Attribute SFWork.VB_VarHelpID = -1

'------------------------------------------------------------------------------------------------------------------------
' SelectionAllFrameWork 作成
'------------------------------------------------------------------------------------------------------------------------
Private Sub Class_Initialize()
    Set SFWork = New SelectionAllFrameWork
End Sub

'------------------------------------------------------------------------------------------------------------------------
' SelectionAllFrameWork 開放
'------------------------------------------------------------------------------------------------------------------------
Private Sub Class_Terminate()
    Set SFWork = Nothing
End Sub

'------------------------------------------------------------------------------------------------------------------------
' SelectionAllFrameWork Run
'------------------------------------------------------------------------------------------------------------------------
Public Sub Run()
    SFWork.Run
End Sub

Private Sub SFWork_SelectionInit(Cancel As Boolean, Undo As Boolean)
    Undo = True
End Sub

Private Sub SFWork_SelectionMain(r As Range, Cancel As Boolean)

    Dim lngCnt As Long
    Dim lngRow As Long
    Dim lngCol As Long

    Dim strBuf As String
    Dim strHead As String
    Dim strBottom As String
    Dim strNum As String
    Dim lngPos As Long
    Dim lngLen As Long
    Dim i As Long
    
    Dim blnStart As Boolean
    Dim lngStartPos As Long
    Dim lngEndPos As Long
    
    
    Dim matches As Object
    Dim match As Object

'    On Error Resume Next

    lngCol = r.Column
    lngRow = r.Row
    lngPos = 0
    
    strBuf = r.FormulaLocal
    
    If IsDate(strBuf) Then
        r.FormulaLocal = DateAdd("d", 1, CDate(strBuf))
    Else
        blnStart = False
        lngStartPos = 1
        lngEndPos = -1
        
'
'                Set objRegx = CreateObject("VBScript.RegExp")
'
'                objRegx.Pattern = "[0-9]年"
'                objRegx.IgnoreCase = True
'                objRegx.Global = True
'
'                If r.HasFormula Then
'
'                    Set matches = objRegx.Execute(r.FormulaLocal)
'
'                    For Each match In matches
'                        match.FirstIndex
'                        match.Value
'
'                    Next
'
'                    r.FormulaLocal = objRegx.Replace(r.FormulaLocal, convEscSeq(strReplace))
'                Else
'                    r.Value = objRegx.Replace(r.Value, convEscSeq(strReplace))
'                End If
'                Set objRegx = Nothing
        
        
        
        
        For i = Len(strBuf) To 1 Step -1
            Select Case Mid$(strBuf, i, 1)
                Case "0" To "9"
                    If blnStart Then
                    Else
                        blnStart = True
                        lngEndPos = i
                        lngPos = lngPos + 1
                    End If
                Case Else
                    If blnStart Then
                        blnStart = False
                        lngStartPos = i + 1
                        Select Case strDate
                            Case "m"
                            Case "yyyy"
                            Case Else
                                Exit For
                        End Select
                    End If
            End Select
        Next
        
        Select Case lngEndPos
            Case -1
            Case Else
                strHead = Mid$(strBuf, 1, lngStartPos - 1)
                strNum = Mid$(strBuf, lngStartPos, lngEndPos - lngStartPos + 1)
                strBottom = Mid$(strBuf, lngEndPos + 1, Len(strBuf) - lngEndPos)
        End Select
        
        r.FormulaLocal = strHead & Format$(Val(strNum) + 1, String(Len(strNum), "0")) & strBottom
    End If
    
End Sub



Public Property Let DateValue(v As Long)
    lngAdd = v
End Property

Public Property Let DateType(v As String)
    strDate = v
End Property



