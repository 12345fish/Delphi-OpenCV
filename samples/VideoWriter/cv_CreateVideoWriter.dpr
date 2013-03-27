// JCL_DEBUG_EXPERT_GENERATEJDBG OFF
// JCL_DEBUG_EXPERT_INSERTJDBG OFF
// JCL_DEBUG_EXPERT_DELETEMAPFILE OFF
program cv_CreateVideoWriter;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  Core.types_c in '..\..\include\�ore\Core.types_c.pas',
  core_c in '..\..\include\�ore\core_c.pas',
  highgui_c in '..\..\include\highgui\highgui_c.pas',
  LibName in '..\..\include\LibName.pas';

Const
  filename = 'Resource\capture.avi';

Var
  capture: pCvCapture;
  fps: Double;
  size: TCvSize;
  writer: pCvVideoWriter;
  frame: PIplImage;
  c: Integer;

begin
  try
    cvNamedWindow('capture');
    // �������� ����� ������������ ������
     capture := cvCreateCameraCapture(CV_CAP_ANY);
    if not Assigned(capture) then
      Halt;
    // ������� ������
    // double fps = cvGetCaptureProperty (capture, CV_CAP_PROP_FPS);
    fps := 15;
    // ������ ��������
    // CvSize size = cvSize( (int)cvGetCaptureProperty( capture, CV_CAP_PROP_FRAME_WIDTH), (int)cvGetCaptureProperty( capture, CV_CAP_PROP_FRAME_HEIGHT));
    size := CvSize(640, 480);
    writer := cvCreateVideoWriter(filename, CV_FOURCC('X', 'V', 'I', 'D'), fps, size, 0);
    if not Assigned(writer) then
      Halt;
    frame := nil;
    while true do
    begin
      // �������� ����
      frame := cvQueryFrame(capture);
      if not Assigned(frame) then
        Break;
      // ��������� � ����
      cvWriteFrame(writer, frame);
      // ����������
      cvShowImage('capture', frame);
      c := cvWaitKey(0);
      if (c = 27) then
        Break; // ���� ������ ESC - �������
    end;
    // ����������� �������
    cvReleaseCapture(capture);
    cvReleaseVideoWriter(writer);
    cvDestroyWindow('capture');
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

end.
