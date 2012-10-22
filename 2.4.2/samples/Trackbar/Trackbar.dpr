program Trackbar;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  Core.types_c in '..\..\include\�ore\Core.types_c.pas',
  core_c in '..\..\include\�ore\core_c.pas',
  highgui_c in '..\..\include\highgui\highgui_c.pas';

Const
  filename = 'clock.avi';

Var
  capture: pCvCapture = nil;
  frame: pIplImage = nil;
  framesCount: Double;
  frames: Integer;
  currentPosition: Integer;
  c: Integer;

  // �������-���������� �������� -
  // ������������ �� ������ ����
procedure myTrackbarCallback(pos: Integer); cdecl;
begin
  cvSetCaptureProperty(capture, CV_CAP_PROP_POS_FRAMES, pos);
end;

begin
  try
    // ���� ��� ����������� ��������
    cvNamedWindow('original', CV_WINDOW_AUTOSIZE);
    // �������� ���������� � �����-�����
    capture := cvCreateFileCapture(filename);
    // �������� ����� ������
    framesCount := cvGetCaptureProperty(capture, CV_CAP_PROP_FRAME_COUNT);
    Writeln('[i] count: ', framesCount);
    frames := Trunc(framesCount);

    currentPosition := 0;
    if (frames <> 0) then
      // ���������� ��������
      cvCreateTrackbar('Position', 'original', @currentPosition, frames, myTrackbarCallback);

    while True do
    begin
      // �������� ��������� ����
      frame := cvQueryFrame(capture);
      if not Assigned(frame) then
        Break;
      // ����� ����� ��������
      // ��������� ���������

      // ���������� ����
      cvShowImage('original', frame);

      c := cvWaitKey(33);
      if (c = 27) then
        Break; // ���� ������ ESC - �������
    end;
    // ����������� �������
    cvReleaseCapture(capture);
    // ������� ����
    cvDestroyWindow('original');
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

end.
