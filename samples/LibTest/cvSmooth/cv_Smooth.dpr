// JCL_DEBUG_EXPERT_GENERATEJDBG OFF
// JCL_DEBUG_EXPERT_INSERTJDBG OFF
// JCL_DEBUG_EXPERT_DELETEMAPFILE OFF
program cv_Smooth;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
uLibName in '..\..\..\include\uLibName.pas',
highgui_c in '..\..\..\include\highgui\highgui_c.pas',
core_c in '..\..\..\include\�ore\core_c.pas',
Core.types_c in '..\..\..\include\�ore\Core.types_c.pas',
imgproc.types_c in '..\..\..\include\imgproc\imgproc.types_c.pas',
imgproc_c in '..\..\..\include\imgproc\imgproc_c.pas',
legacy in '..\..\..\include\legacy\legacy.pas',
calib3d in '..\..\..\include\calib3d\calib3d.pas',
imgproc in '..\..\..\include\imgproc\imgproc.pas',
haar in '..\..\..\include\objdetect\haar.pas',
objdetect in '..\..\..\include\objdetect\objdetect.pas',
tracking in '..\..\..\include\video\tracking.pas',
Core in '..\..\..\include\�ore\core.pas'
  ;

Const
  // ��� ��������
  filename = 'Resource\cat2.jpg';

Var
  image: PIplImage = nil;
  dst: PIplImage = nil;

begin
  try
    // �������� ��������
    image := cvLoadImage(filename, 1);
    // ��������� ��������
    dst := cvCloneImage(image);
    Writeln('[i] image: ', filename);
    if not Assigned(image) then
      Halt;
    // ���� ��� ����������� ��������
    cvNamedWindow('original', CV_WINDOW_AUTOSIZE);
    cvNamedWindow('Smooth', CV_WINDOW_AUTOSIZE);
    // ���������� �������� ��������
     cvSmooth(image, dst, CV_GAUSSIAN, 3, 3);
//    cvSmooth(image, dst, CV_BLUR_NO_SCALE, 3, 3);
    // ���������� ��������
    cvShowImage('original', image);
    cvShowImage('Smooth', dst);
    // ��� ������� �������
    cvWaitKey(0);
    // ����������� �������
    cvReleaseImage(image);
    cvReleaseImage(dst);
    // ������� ����
    cvDestroyWindow('original');
    cvDestroyWindow('Smooth');
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

end.
