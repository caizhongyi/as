<?php
echo md5("fdafdsa".time()."sfs".rand(1000,9999));exit;
$updir="./";      //�ϴ�Ŀ¼.Ϊ�˼���Unix��ϵͳ������������ʾup.php��ͬĿ¼�ȽϺá�
if($_FILES["image"][error]==0){//�ϴ��ļ��޴���
$upload_file=$_FILES["image"];
$upload_file['filename']=$updir.$upload_file['name'];  //�ƶ���������·��
move_uploaded_file($upload_file["tmp_name"],"pic/".$upload_file["filename"]);
	}
else{
echo "�ϴ��ļ�ʧ�ܣ�����ţ�".$_FILES["image"][error];
}
$result = array();
$result["total"] = 28;
$result["image"] = array("upload/aaaaaaaaa.jpg","upload/bbbb.jpg","upload/ccccc.jpg","upload/ddddd.jpg","upload/eeeee.jpg");
echo serialize($result);
?>