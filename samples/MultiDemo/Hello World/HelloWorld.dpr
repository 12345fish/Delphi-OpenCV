{$APPTYPE CONSOLE}
// JCL_DEBUG_EXPERT_GENERATEJDBG OFF
// JCL_DEBUG_EXPERT_INSERTJDBG OFF
// JCL_DEBUG_EXPERT_DELETEMAPFILE OFF
program HelloWorld;

{$R *.res}

uses
  System.SysUtils,
  highgui_c in '..\..\..\include\highgui\highgui_c.pas',
  core_c in '..\..\..\include\�ore\core_c.pas',
  Core.types_c in '..\..\..\include\�ore\Core.types_c.pas',
  uLibName in '..\..\..\include\uLibName.pas',
  types_c in '..\..\..\include\�ore\types_c.pas';

Var
  // ����� ������ � ������ ��������
  height: Integer = 620;
  width: Integer = 440;
  pt: TCvPoint;
  hw: pIplImage;
  font: TCvFont;

begin
  try
    // ����� ����� ��� ������ ������
    pt := CvPoint(height div 4, width div 2);
    // ������ 8-������, 3-��������� ��������
    hw := cvCreateImage(CvSize(height, width), 8, 3);
    // �������� �������� ������ ������
    CvSet(pCvArr(hw), cvScalar(0, 0, 0));
    // ������������� ������
    cvInitFont(@font, CV_FONT_HERSHEY_COMPLEX, 1.0, 1.0, 0, 1, CV_AA);
    // ��������� ����� ������� �� �������� �����
    cvPutText(hw, 'OpenCV Step By Step', pt, @font, CV_RGB(150, 0, 150));
    // ������ ������
    cvNamedWindow('Hello World', 0);
    // ���������� �������� � ��������� ����
    cvShowImage('Hello World', hw);
    // ��� ������� �������
    cvWaitKey(0);
    // ����������� �������
    cvReleaseImage(hw);
    cvDestroyWindow('Hello World');
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

end.
