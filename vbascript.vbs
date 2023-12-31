Sub stockdata()

    Dim LastRow As Double
    Dim OpeningPrice As Single
    Dim ClosingPrice As Single
    Dim Volume As Double
    Dim selrow As Double
    Dim iselect As Double
    Dim increased As Double
    Dim ws As Worksheet
    
    For Each ws In ThisWorkbook.Worksheets
        ws.Activate
        
        iselect = 2
        Row2 = 2
        Volume = 0
        selrow = 2
        LastRow = ActiveSheet.Range("A" & Rows.Count).End(xlUp).Row
       
        ws.Cells(1, 9) = "ticker"
        ws.Cells(1, 10) = "yearly change"
        ws.Cells(1, 11) = "percent change"
        ws.Cells(4, 15) = "greatest total volume"
        ws.Cells(1, 16) = "ticker"
        ws.Cells(1, 17) = "value"
       
        For i = Row2 To LastRow
            ticker1 = Cells(i, 1).Value
            ticker2 = Cells(i - 1, 1).Value
            If ticker1 <> ticker2 Then
                Cells(selrow, 9).Value = ticker1
                selrow = selrow + 1
            End If
           
        Next i
   
        For i = Row2 To LastRow + 1
            ticker1 = Cells(i, 1).Value
            ticker2 = Cells(i - 1, 1).Value
                If ticker1 = ticker2 And i > 2 Then
                    Volume = Volume + Cells(i, 7).Value
                ElseIf i > 2 Then
                    Cells(iselect, 12).Value = Volume
                    iselect = iselect + 1
                    Volume = 0
                Else
                    Volume = Volume + Cells(i, 7).Value
               
                End If
           
        Next i
         
        iselect = 2
       
        For i = Row2 To LastRow
            If Cells(i, 1).Value <> Cells(i - 1, 1).Value Then
                OpeningPrice = Cells(i, 3).Value
            ElseIf Cells(i, 1).Value <> Cells(i + 1, 1).Value Then
                ClosingPrice = Cells(i, 6).Value
               
            End If
           
            If ClosingPrice > 0 And OpeningPrice > 0 Then
                increased = ClosingPrice - OpeningPrice
                percentincrease = increased / OpeningPrice
                OpeningPrice = 0
                ClosingPrice = 0
                Cells(iselect, 11).Value = FormatPercent(percentincrease)
                Cells(iselect, 10).Value = increased
                iselect = iselect + 1
                Range("J:J").NumberFormat = "0.00"
                
            End If
           
        Next i
       
        percent_min = Application.WorksheetFunction.Min(ActiveSheet.Columns("k:k"))
        percent_max = Application.WorksheetFunction.Max(ActiveSheet.Columns("k:k"))
        volume_max = Application.WorksheetFunction.Max(ActiveSheet.Columns("l:l"))
        Range("Q3").Value = FormatPercent(percent_min)
        Range("Q2").Value = FormatPercent(percent_max)
        Range("Q4").Value = volume_max
        
        ws.Cells(1, 12) = "total stock volume"
        ws.Cells(2, 15) = "greatest % increase"
        ws.Cells(3, 15) = "greatest % decrease"
        
        For i = Row2 To LastRow
            If percent_max = Cells(i, 11).Value Then
                Range("P2").Value = Cells(i, 9).Value
            ElseIf percent_min = Cells(i, 11).Value Then
                Range("P3").Value = Cells(i, 9).Value
            ElseIf volume_max = Cells(i, 12).Value Then
                Range("P4").Value = Cells(i, 9).Value
           
            End If
           
        Next i
       
        For i = Row2 To LastRow
            If IsEmpty(Cells(i, 10).Value) Then Exit For
            If Cells(i, 10).Value > 0 Then
                Cells(i, 10).Interior.ColorIndex = 4
            Else
                Cells(i, 10).Interior.ColorIndex = 3
           
            End If
           
        Next i
        
        ws.Columns("I:Q").AutoFit
        
    Next ws
   

End Sub