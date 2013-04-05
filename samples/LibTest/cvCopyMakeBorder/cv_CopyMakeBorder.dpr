// JCL_DEBUG_EXPERT_GENERATEJDBG OFF
// JCL_DEBUG_EXPERT_INSERTJDBG OFF
// JCL_DEBUG_EXPERT_DELETEMAPFILE OFF
program cv_CopyMakeBorder;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
{$I ..\..\uses_include.inc}
  ;

const
  filename = 'Resource\opencv_logo_with_text.png';

Var
  image: pIplImage = nil;
  dst: pIplImage = nil;
  dst2: pIplImage = nil;

begin
  try
    // �������� ��������
    image := cvLoadImage(filename, 1);
    WriteLn(Format('[i] image: %s', [filename]));
    // ������ ��������
    dst := cvCreateImage(cvSize(image^.width + 20, image^.height + 20), image^.depth, image^.nChannels);
    dst2 := cvCreateImage(cvSize(image^.width + 20, image^.height + 20), image^.depth, image^.nChannels);

    // ���� ��� ����������� ��������
    cvNamedWindow('original', CV_WINDOW_AUTOSIZE);
    cvNamedWindow('IPL_BORDER_CONSTANT', CV_WINDOW_AUTOSIZE);
    cvNamedWindow('IPL_BORDER_REPLICATE', CV_WINDOW_AUTOSIZE);

    // ��������� ��������
    cvCopyMakeBorder(image, dst, cvPoint(10, 10), IPL_BORDER_CONSTANT, cvScalar(250));
    cvCopyMakeBorder(image, dst2, cvPoint(10, 10), IPL_BORDER_REPLICATE, cvScalar(250));

    // ���������� ��������
    cvShowImage('original', image);
    cvShowImage('IPL_BORDER_CONSTANT', dst);
    cvShowImage('IPL_BORDER_REPLICATE', dst2);

    // ��� ������� �������
    cvWaitKey(0);

    // ����������� �������
    cvReleaseImage(&image);
    cvReleaseImage(&dst);
    cvReleaseImage(&dst2);
    // ������� ����
    cvDestroyAllWindows();
  except
    on E: Exception do
      WriteLn(E.ClassName, ': ', E.Message);
  end;

end.
