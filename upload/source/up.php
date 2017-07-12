<?php
echo md5("fdafdsa".time()."sfs".rand(1000,9999));exit;
$updir="./";      //上传目录.为了兼容Unix类系统，还是这样表示up.php的同目录比较好。
if($_FILES["image"][error]==0){//上传文件无错误
$upload_file=$_FILES["image"];
$upload_file['filename']=$updir.$upload_file['name'];  //移动到的完整路径
move_uploaded_file($upload_file["tmp_name"],"pic/".$upload_file["filename"]);
	}
else{
echo "上传文件失败，错误号：".$_FILES["image"][error];
}
$result = array();
$result["total"] = 28;
$result["image"] = array("upload/aaaaaaaaa.jpg","upload/bbbb.jpg","upload/ccccc.jpg","upload/ddddd.jpg","upload/eeeee.jpg");
echo serialize($result);
?>