// JCL_DEBUG_EXPERT_GENERATEJDBG OFF
// JCL_DEBUG_EXPERT_INSERTJDBG OFF
// JCL_DEBUG_EXPERT_DELETEMAPFILE OFF
program cv_Smooth;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
{$I ..\..\uses_include.inc}
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
