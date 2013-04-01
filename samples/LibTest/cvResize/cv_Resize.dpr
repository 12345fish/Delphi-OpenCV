// JCL_DEBUG_EXPERT_GENERATEJDBG OFF
// JCL_DEBUG_EXPERT_INSERTJDBG OFF
// JCL_DEBUG_EXPERT_DELETEMAPFILE OFF
program cv_Resize;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  Core.types_c in '..\..\..\include\�ore\Core.types_c.pas',
  core_c in '..\..\..\include\�ore\core_c.pas',
  highgui_c in '..\..\..\include\highgui\highgui_c.pas',
  imgproc.types_c in '..\..\..\include\imgproc\imgproc.types_c.pas',
  imgproc_c in '..\..\..\include\imgproc\imgproc_c.pas',
  uLibName in '..\..\..\include\uLibName.pas',
  types_c in '..\..\..\include\�ore\types_c.pas';

Const
  // ��� ��������
  filename = 'Resource\cat2.jpg';

Var
  // ��������
  image: PIplImage = nil;
  dst: array [0 .. 3] of PIplImage;
  i: Integer;

begin
  try
    image := cvLoadImage(filename, 1);
    i := 0;
    Writeln('[i] image: ', filename);
    if not Assigned(image) then
      Halt;

    // �������� ����������� �������� (������ ��� ������������)
    for i := 0 to 3 do
    begin
      dst[i] := cvCreateImage(cvSize(image^.width div 3, image^.height div 3), image^.depth,
        image^.nChannels);
      cvResize(image, dst[i], i);
    end;

    // ���� ��� ����������� ��������
    cvNamedWindow('original', CV_WINDOW_AUTOSIZE);
    cvShowImage('original', image);

    // ���������� ���������
    for i := 0 to 3 do
    begin
      cvNamedWindow(PCVChar(IntToStr(i)), CV_WINDOW_AUTOSIZE);
      cvShowImage(PCVChar(IntToStr(i)), dst[i]);
    end;

    // ��� ������� �������
    cvWaitKey(0);
    // ����������� �������
    cvReleaseImage(image);
    // ������� ����
    cvDestroyAllWindows();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

end.
