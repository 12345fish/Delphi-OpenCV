{$APPTYPE CONSOLE}
program HelloWorld;

{$R *.res}

uses
  System.SysUtils,
  highgui_c in '..\..\include\highgui\highgui_c.pas',
  core_c in '..\..\include\�ore\core_c.pas',
  types_c in '..\..\include\�ore\types_c.pas';

Var
  // ����� ������ � ������ ��������
  height: Integer = 620;
  width: Integer = 440;
  pt: CvPoint;
  hw: pIplImage;

  // font: CvFont;
begin
  try
    // ����� ����� ��� ������ ������
    pt := CV._CvPoint(height div 4, width div 2);
    // ������ 8-������, 3-��������� ��������
    hw := cvCreateImage(CV._cvSize(height, width), 8, 3);
    // �������� �������� ������ ������
     cvSet(hw, CV._cvScalar(0, 0, 0));
    // ������������� ������
    // cvInitFont(&font, CV_FONT_HERSHEY_COMPLEX, 1.0, 1.0, 0, 1, CV_AA);
    // ��������� ����� ������� �� �������� �����
    // cvPutText(hw, " OpenCV Step By Step ", pt, &font, CV_RGB(150, 0, 150));
    // ������ ������
     cvNamedWindow('Hello World', 0);
    // ���������� �������� � ��������� ����
     cvShowImage('Hello World', hw);
    // ��� ������� �������
     cvWaitKey(0);
    // ����������� �������
     cvReleaseImage(@hw);
     cvDestroyWindow('Hello World');
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

end.
