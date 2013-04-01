// JCL_DEBUG_EXPERT_GENERATEJDBG OFF
// JCL_DEBUG_EXPERT_INSERTJDBG OFF
// JCL_DEBUG_EXPERT_DELETEMAPFILE OFF
program cv_SetMouseCallback;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  Core.types_c in '..\..\..\include\�ore\Core.types_c.pas',
  core_c in '..\..\..\include\�ore\core_c.pas',
  highgui_c in '..\..\..\include\highgui\highgui_c.pas',
  uLibName in '..\..\..\include\uLibName.pas',
  types_c in '..\..\..\include\�ore\types_c.pas';

Const
  // ��� ��������
  filename = 'Resource\opencv_logo_with_text.png';

Var
  image: PIplImage = nil;
  c: Integer;

  // ������ �������������
procedure drawTarget(img: PIplImage; x, y, radius: Integer); cdecl;
begin
  cvCircle(img, cvPoint(x, y), radius, CV_RGB(250, 0, 0), 1, 8);
  cvLine(img, cvPoint(x - radius div 2, y - radius div 2), cvPoint(x + radius div 2, y + radius div 2),
    CV_RGB(250, 0, 0), 1, 8);
  cvLine(img, cvPoint(x - radius div 2, y + radius div 2), cvPoint(x + radius div 2, y - radius div 2),
    CV_RGB(250, 0, 0), 1, 8);
end;

// ���������� ������� �� �����
procedure myMouseCallback(event: Integer; x: Integer; y: Integer; flags: Integer;
  param: Pointer); cdecl;
Var
  img: PIplImage;
begin
  img := PIplImage(param);
  if event = CV_EVENT_LBUTTONDOWN then
  begin
    Writeln(Format('%d x %d', [x, y]));
    drawTarget(img, x, y, 10);
  end;
end;

begin
  try
    // �������� ��������
    image := cvLoadImage(filename, 1);
    Writeln('[i] image: ', filename);
    if not Assigned(image) then
      Halt;
    // ���� ��� ����������� ��������
    cvNamedWindow('original', CV_WINDOW_AUTOSIZE);
    // ������ ���������� �����
    cvSetMouseCallback('original', myMouseCallback, image);

    while True do
    begin
      // ���������� ��������
      cvShowImage('original', image);
      c := cvWaitKey(33);
      if (c = 27) then
        break;
    end;

    // ����������� �������
    cvReleaseImage(image);
    // ������� ����
    cvDestroyWindow('original');
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

end.
