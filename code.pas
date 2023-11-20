var
  MyGameForm:TclGameForm;
  MyMQTT : TclMQTT;
  BtnBasla,BtnDur: TclButton;
  SndFire:Integer;
  mainPnl,imgMainPnl,imgPnl,imgIciPnl,descriptionPnl : TclProPanel;
  iconImg,iconGiftImg,iconIndicatorBarImg,captionImg : TClProImage;
  CekilisTimer:TClTimer;
  dondur : Integer;
  InformationLbl : TClProLabel;
  CekilisBtn : TClProButton;
  QMemList:TclJSonQuery;
  winUserGUID,executiveUserGUID : String;
  
  (*Procedure BtnBaslaClick;
  begin
    MyGameForm.PlayGameSound(SndFire);
  End;
  
  Procedure BtnDurClick;
  begin
    MyGameForm.SoundIsActive:=False;
  End;*)
    Procedure MyMQTTPublishReceived;
  begin
    If Not Clomosy.PlatformIsMobile Then //WINDOWS ISE
    begin
      //If MyMQTT.ReceivedAlright Then
        //InformationLbl.Caption :=  MyMQTT.ReceivedMessage;
      If CekilisTimer.Enabled And (MyMQTT.ReceivedMessage = 'durdur') Then
      begin
      
        if Clomosy.AppUserProfile = 1 then 
        begin
          CekilisBtn.Visible := False;
        end;
        
        if not Clomosy.PlatformIsMobile then
        begin //WINDOWS  
          CekilisBtn.Enabled := True;
        end;
        
        //MyGameForm.SoundIsActive:=False;
        CekilisTimer.Enabled := False;
        CekilisBtn.Caption := 'Devam et';
        InformationLbl.Caption := QMemList.FieldByName('Member_Name').AsString;
        Clomosy.SendNotification('','Tebrikler Çekilişi Kazandınız',QMemList.FieldByName('Member_GUID').AsString);
        MyMQTT.Send('TALİHLİ:'+#13+ InformationLbl.Caption);
      End;
      if MyMQTT.ReceivedMessage = 'basladi' then
      begin 
          CekilisBtn.Enabled := True; 
          If CekilisTimer.Enabled Then 
          begin
          CekilisBtn.Caption := 'Bekle';
          //MyGameForm.SoundIsActive:=False;
          end
          Else 
          begin
          CekilisBtn.Caption := 'Devam et';
          //MyGameForm.SoundIsActive:=False;
          end;
          QMemList.Filter := 'Member_GUID <> '+QuotedStr(winUserGUID);
          QMemList.Filtered := True;
     end;
    End Else //WIN DEGILSE
    begin
      If POS('TALİHLİ:',MyMQTT.ReceivedMessage)>0 Then
        InformationLbl.Caption :=  'KAZANAN ' + MyMQTT.ReceivedMessage;
        if MyMQTT.ReceivedMessage = 'basladi' then
        begin
          if Clomosy.AppUserProfile = 1 then 
          begin //YONETİCİ
            CekilisBtn.Visible := True;
            CekilisBtn.Text := 'Çekilişi Durdur';
            MyGameForm.AddNewEvent(CekilisBtn,tbeOnClick,'BtnCekilisYapClick');
            
            QMemList.Filter := 'Member_GUID <> '+QuotedStr(executiveUserGUID);
            QMemList.Filtered := True;
          end;
        end;
    End;
  End;
  
  

 
 Procedure ProcOnCekilisTimer;
  begin
    InformationLbl.Caption := QMemList.FieldByName('Member_Name').AsString;
    Clomosy.ProcessMessages;
    QMemList.Next;
    
    If QMemList.EOF Then QMemList.First;
    
    if dondur >= 360 then
    begin
      dondur := 50;
    end;
     iconImg.RotationAngle :=  dondur;
     dondur := dondur - 50;
    
  End;

Procedure BtnCekilisYapClick;
  Begin
    MyMQTT.Send('durdur');
  End;
  
    procedure BtnIsimKatistirClick;
  Begin
    
    If Not CekilisTimer.Enabled Then
    begin
      QMemList := Clomosy.DBCloudQueryWith(ftMembers,'','ISNULL(PMembers.Rec_Deleted,0)=0 ORDER BY NEWID()');//her seferinde karışık member listesi al
      
      //MyGameForm.PlayGameSound(SndFire);
    end;
      
    CekilisTimer.Enabled := Not CekilisTimer.Enabled;
    InformationLbl.Caption := '';
    
    MyMQTT.Send('basladi');
    
  End;
  
begin
  dondur := -50;
  MyGameForm := TclGameForm.Create(Self);
  MyGameForm.SetFormBGImage('https://clomosy.com/theme/SurveyStyle5.png');
  MyGameForm.LytTopBar.Visible :=True;
  //MyGameForm.AddGameAssetFromUrl('https://clomosy.com/educa/cekilisMuzigi.wav');
  //SndFire := MyGameForm.RegisterSound('cekilisMuzigi.wav');
  //MyGameForm.SoundIsActive:=True;
  
  MyMQTT := MyGameForm.AddNewMQTTConnection(MyGameForm,'MyMQTT');
  MyGameForm.AddNewEvent(MyMQTT,tbeOnMQTTPublishReceived,'MyMQTTPublishReceived');
  MyMQTT.Channel := 'cekilis';//project guid + channel
  MyMQTT.Connect;
  
  mainPnl:=MyGameForm.AddNewProPanel(MyGameForm,'mainPnl');
  clComponent.SetupComponent(mainPnl,'{"Align" : "Client"}');
  
  captionImg := MyGameForm.AddNewProImage(mainPnl,'captionImg');
  clComponent.SetupComponent(captionImg,'{"Align" : "MostTop","Height":'+IntToStr(mainPnl.Height/3)+',"MarginTop":15,"ImgUrl":"https://clomosy.com/demos/lotterytime.png", "ImgFit":"yes"}');
  
  
  //ÇARK ANA PANEL
  imgMainPnl:=MyGameForm.AddNewProPanel(mainPnl,'imgMainPnl');
  clComponent.SetupComponent(imgMainPnl,'{"Align" : "Top","MarginTop":30,"MarginLeft":'+IntToStr(mainPnl.Width/9)+',"MarginRight":'+IntToStr(mainPnl.Width/9)+',
  "Height":'+IntToStr(mainPnl.Height/3)+'}');
  
  //ÇARK RESİMLERİ İÇİN OLUŞTURULAN PANEL
  imgPnl:=MyGameForm.AddNewProPanel(imgMainPnl,'imgPnl');
  clComponent.SetupComponent(imgPnl,'{"Align" : "Center","Width":'+IntToStr(imgMainPnl.Height)+',
  "Height":'+IntToStr(imgMainPnl.Height)+'}');
  
  iconImg := MyGameForm.AddNewProImage(imgPnl,'iconImg');
  clComponent.SetupComponent(iconImg,'{"Align" : "Client","ImgUrl":"https://clomosy.com/demos/wheel.png", "ImgFit":"yes"}');
  
  //ÇARK İÇİNDEKİ RESİMLER İÇİN PANEL
  imgIciPnl:=MyGameForm.AddNewProPanel(imgPnl,'imgIciPnl');
  clComponent.SetupComponent(imgIciPnl,'{"Align" : "Center","Height":'+IntToStr(imgPnl.Height/3)+',"Width":'+IntToStr(imgPnl.Width)+'}');
  
  iconGiftImg := MyGameForm.AddNewProImage(imgIciPnl,'iconGiftImg');
  clComponent.SetupComponent(iconGiftImg,'{"Align" : "Center","Height":'+IntToStr(imgIciPnl.Height)+',"ImgUrl":"https://clomosy.com/demos/gift.png", "ImgFit":"yes","MarginLeft":'+IntToStr(imgIciPnl.Width/6)+'}');
  
  iconIndicatorBarImg := MyGameForm.AddNewProImage(imgIciPnl,'iconIndicatorBarImg');
  clComponent.SetupComponent(iconIndicatorBarImg,'{"Align" : "Right","Width":'+IntToStr(imgIciPnl.Width/6)+',"ImgUrl":"https://clomosy.com/demos/indicatorbar.png", "ImgFit":"yes"}');
  
  InformationLbl := MyGameForm.AddNewProLabel(mainPnl,'InformationLbl','');
  clComponent.SetupComponent(InformationLbl,'{"Align" : "Top","MarginTop":10,"Height":'+IntToStr(mainPnl.Height/9)+',"MarginLeft":'+IntToStr(mainPnl.Width/9)+',"MarginRight":'+IntToStr(mainPnl.Width/9)+',
  "TextColor":"#f50505","TextSize":16,"TextVerticalAlign":"center", "TextHorizontalAlign":"center","TextBold":"yes"}');
  
  CekilisBtn := MyGameForm.AddNewProButton(mainPnl,'CekilisBtn','');
  clComponent.SetupComponent(CekilisBtn,'{"Align" : "MostBottom","MarginBottom":20, "MarginTop":5,"TextColor":"#2705eb","TextBold":"yes",
  "RoundHeight":3,"RoundWidth":3,"BackgroundColor":"#e3c76b","Height":'+IntToStr(mainPnl.Height/12)+',"MarginLeft":'+IntToStr(mainPnl.Width/4)+',"MarginRight":'+IntToStr(mainPnl.Width/4)+'}');
  CekilisBtn.Visible := False;
  
    QMemList := Clomosy.DBCloudQueryWith(ftMembers,'','ISNULL(PMembers.Rec_Deleted,0)=0 ORDER BY NEWID()');
    
  
  if not Clomosy.PlatformIsMobile then
  begin //WINDOWS
    winUserGUID := Clomosy.AppUserGUID;
    QMemList.Filter := 'Member_GUID <> '+QuotedStr(winUserGUID);
    QMemList.Filtered := True;
    
    
    InformationLbl.Text := 'ÇEKİLİŞİ BAŞLATMAK İÇİN'#13' BUTONA BASIN...';
    CekilisBtn.Visible := True;
    CekilisBtn.Text := 'Çekilişe Başla';
    MyGameForm.AddNewEvent(CekilisBtn,tbeOnClick,'BtnIsimKatistirClick');
    
  
    CekilisTimer:= MyGameForm.AddNewTimer(MyGameForm,'CekilisTimer',1000);  
    CekilisTimer.Interval := 300;//100 milisaniye aralıklarla 
    CekilisTimer.Enabled := False;
    MyGameForm.AddNewEvent(CekilisTimer,tbeOnTimer,'ProcOnCekilisTimer');
    
    
  end else
  begin
    if Clomosy.AppUserProfile = 1 then
    begin //YÖNETİCİİ
      InformationLbl.Text := 'ÇEKİLİŞ BAŞLADIKTAN SONRA'#13' DURDURMAK İÇİN BUTONA BASIN...';
      executiveUserGUID := Clomosy.AppUserGUID;
      QMemList.Filter := 'Member_GUID <> '+QuotedStr(executiveUserGUID);
      QMemList.Filtered := True;
      
    
    end else
    begin // OYUNCULAR
      InformationLbl.Text := 'ÇEKİLİŞ BEKLENİYOR';
    end;
  end;
  
  
  
  
  
  (*BtnBasla:= MyGameForm.AddNewButton(MyGameForm,'BtnBasla','başla');
  MyGameForm.AddNewEvent(BtnBasla,tbeOnClick,'BtnBaslaClick');
  BtnBasla.Align := almostBottom;
  
   BtnDur:= MyGameForm.AddNewButton(MyGameForm,'BtnDur','durdur');
  MyGameForm.AddNewEvent(BtnDur,tbeOnClick,'BtnDurClick');
  BtnDur.Align := alBottom;*)
  
  
  MyGameForm.Run;
End;