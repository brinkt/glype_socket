require "spec_helper"

#-------------------------------------------------------------------------------------#
# config

salt = "wrRRuhzjuNlvJr4e5cpTbQA430QPd4szj9hDeEKxhVSPdMT6N6OONeJE3nj6hBwqyBRD3s0abGPei"+
"x9TrNy4P5wIiGDq5XEumkVfCJdDfRGlcD5tgrmTmIqueTI8EbsQ"

#-------------------------------------------------------------------------------------#
# encoded urls within stylesheet code

body1 = ".gbto .gbzt .gbtb2,.gbto .gbgt .gbtb2{border-top-width:0}.gbtb .gbts{backgro"+
"und:url(/browse.php/pjS1Xkvh/tlXSunj5/6EDda0yA/_2B59zQR/ckJJcaZF/Lal4eceZ/of5GE2Vk/h"+
"oXg_3D_/3D/b5/);_background:url(/browse.php/pjS1Xkvh/tlXSunj5/6EDda0yA/_2B59zQR/ckJJ"+
"caZF/La8ODLes/pM42c7HB/Z2V0E_3D/b5/);background-position:-27px -22px;border:0;font-s"+
"ize:0;padding:29px 0 0;*padding:27px 0 0;width:1px}.gbzt:hover,"

result1 = ".gbto .gbzt .gbtb2,.gbto .gbgt .gbtb2{border-top-width:0}.gbtb .gbts{backg"+
"round:url(http://ssl.gstatic.com/gb/images/b_8d5afc09.png);_background:url(http://ss"+
"l.gstatic.com/gb/images/b8_3615d64d.png);background-position:-27px -22px;border:0;fo"+
"nt-size:0;padding:29px 0 0;*padding:27px 0 0;width:1px}.gbzt:hover,"

#-------------------------------------------------------------------------------------#
# encoded urls within HTML

body2 = 'Shopping</a></li><li class=gbmtc><a onclick=gbar.logger.il(1,{t:30}); class='+
'gbmt id=gb_30 href="/browse.php/pjS1Wk_2/F6tlDNoX/7q5FHda0/yA_2B8dl/Dxx0Mpo_/3D/b5/"'+
'>Blogger</a></li><li class=gbmtc><a onclick=gbar.logger.il(1,{t:27}); class=gbmt id='+
'gb_27 href="/browse.php/pjS1Wk_2/F6tlXOoX/7h5A2QZ0/7CspF_2F/DxAqIM8L/dh_2BFv9/o_3D/b'+
'5/">Finance</a></li><li class=gbmtc><a onclick=gbar.logger.il(1,{t:31}); class=gbmt '+
'id=gb_31 href="/browse.php/7yG1Akjl/90bOvTfq/7kyUZEbD/t5d8QUE9/JJJCYAye/uN6fKbId/uj9'+
'gFl0_/3D/b5/">Photos</a></li><li class'

result2 = 'Shopping</a></li><li class=gbmtc><a onclick=gbar.logger.il(1,{t:30}); clas'+
's=gbmt id=gb_30 href="http://www.blogger.com/?tab=wj">Blogger</a></li><li class=gbmt'+
'c><a onclick=gbar.logger.il(1,{t:27}); class=gbmt id=gb_27 href="http://www.google.c'+
'om/finance?tab=we">Finance</a></li><li class=gbmtc><a onclick=gbar.logger.il(1,{t:31'+
'}); class=gbmt id=gb_31 href="https://photos.google.com/?tab=wq&pageId=none">Photos<'+
'/a></li><li class'

#-------------------------------------------------------------------------------------#

describe GlypeSocket::Decoder do
  config = { salt: salt, script: 'browse.php'}
  
  it "should decode urls within inline stylesheet code" do
    expect( GlypeSocket::Decoder.decode(body1,config) ).to eq(result1)
  end

  it "should decode urls within HTML code" do
    expect( GlypeSocket::Decoder.decode(body2,config) ).to eq(result2)
  end

end
