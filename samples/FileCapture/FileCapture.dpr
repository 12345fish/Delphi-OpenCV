program FileCapture;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  Core.types_c in '..\..\include\�ore\Core.types_c.pas',
  core_c in '..\..\include\�ore\core_c.pas',
  highgui_c in '..\..\include\highgui\highgui_c.pas',
  LibName in '..\..\include\LibName.pas';

Var
  capture: PCvCapture;
  width: Double;
  height: Double;
  frame: PIplImage;
  counter: Integer;
  filename: pCVChar;
  c: Integer;

begin
  try
    // �������� ����� ������������ ������
    capture := cvCreateFileCapture('rtsp://admin:admin@192.168.0.105:554/VideoInput/1/h264/2'); // cvCaptureFromCAM( 0 );
//    capture := cvCreateFileCapture('rtsp://admin:admin@192.168.0.105:554/VideoInput/1/h264/1'); // cvCaptureFromCAM( 0 );
//    capture := cvCreateFileCapture('rtsp://admin:admin@192.168.0.105:554/cam/realmonitor?channel=1&subtype=1');
    if not Assigned(capture) then
      Halt;
    // ������ ������ � ������ �����
    width := cvGetCaptureProperty(capture, CV_CAP_PROP_FRAME_WIDTH);
    height := cvGetCaptureProperty(capture, CV_CAP_PROP_FRAME_HEIGHT);
    WriteLn(Format('[i] %.0f x %.0f', [width, height]));
    frame := Nil;
    cvNamedWindow('capture', CV_WINDOW_AUTOSIZE);
    WriteLn('[i] press Enter for capture image and Esc for quit!');
    counter := 0;
    filename := AllocMem(512);

    while true do
    begin
      // �������� ����
      frame := cvQueryFrame(capture);
      // ����������
      cvShowImage('capture', frame);
      c := cvWaitKey(33);
      if (c = 27) then
        Break
      else if (c = 13) then
      begin
        // ��������� ���� � ����
        filename := PCVChar(AnsiString(Format('Image %d.jpg'#0, [counter])));
        WriteLn('[i] capture - ', filename);
        cvSaveImage(filename, frame);
        Inc(counter);
      end;
    end;
    // ����������� �������
    cvReleaseCapture(capture);
    cvDestroyWindow('capture');
  except
    on E: Exception do
      WriteLn(E.ClassName, ': ', E.Message);
  end;

end.
