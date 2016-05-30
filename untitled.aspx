

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="user-scalable=no, initial-scale=1.0, maximum-scale=1.0" />
    <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
    <meta http-equiv="Pragma" content="no-cache" />
    <meta http-equiv="Expires" content="0" />
    <title>Memobird:To 咕咕机(角落咖啡)</title>
    <link href="../css/Style.css" rel="stylesheet" />
    <script src="../Scripts/jquery-1.8.2.min.js"></script>
    <script src="../Scripts/LocalResizeIMG.js"></script>
    <script src="../Scripts/mobileBUGFix.mini.js"></script>
    <script>
        $(function () {
            //清除图片
            $("#btnClearImg").click(function () {
                $("#content").show();
                $("#imgInputView").hide();
                var imgMsg = $("#imgView");
                var imgLable = $("#imgLable");
                var addImg = $("#addImg");

                $("#imgPrint").html("");
                $("#addImg").attr("src", "/Images/ico_add_picture_unchecked.png");
                imgMsg.val("");
                imgLable.removeClass("imgView");
                imgLable.addClass("toolbtn");
                addImg.removeClass("addImgView");
                addImg.addClass("addImg");
                addImg.attr("state", "0");
            });
            $("#btnReturn").click(function () {
                $("#content").show();
                $("#imgInputView").hide();
            });
            $("#imgLable").click(function () {
                var addImg = $("#addImg");
                var uploadImage = $("#uploadImage");
                uploadImage.removeAttr("disabled");
                var state = addImg.attr("state");
                if (state == 1) {
                    $("#content").hide();
                    $("#btnInsertImg").hide();
                    $("#btnClearImg").show();
                    uploadImage.attr("disabled", "disabled");
                    $("#imgInputView").show();
                    $("#status").hide();
                    $("#preloader").hide();
                    $("#imgView").attr("src", $("#imgInsert").attr("src"));
                }
            });
            //上传图片
            $("#uploadImage").live("change", function (event) {
                $("#btnInsertImg").show();
                $("#btnClearImg").hide();
                $("#content").hide();
                $("#status").show();
                $("#preloader").show();
            });
            $("#uploadImage").localResizeIMG({
                width: 384,
                quality: 1,
                success: function (result) {
                    if (result.code != 0) {
                        var _data = {
                            "DataType": "uploadImg",
                            "imgBase64": result.clearBase64
                        };

                        var obj = $.ajax({
                            url: "../ashx/DBInterface.ashx",
                            type: "POST",
                            data: _data,
                            async: false
                        }).responseText;

                        var imgpath = "../" + obj;
                        var imgLable = $("#imgLable");
                        var addImg = $("#addImg");
                        var _h = '<img id="imgInsert" class="imgInsert" src="' + imgpath + '">';
                        $("#imgPrint").html(_h);
                        addImg.attr("src", imgpath);
                        imgLable.addClass("imgView");
                        imgLable.removeClass("toolbtn");
                        addImg.addClass("addImgView");
                        addImg.removeClass("addImg");
                        addImg.attr("state", "1");

                    } else {
                        $("#err").html("图片过大！");
                        $("#err").show();
                        setTimeout(function () { $("#err").html("&nbsp;"); $("#err").hide() }, 3000);
                    }
                    $("#imgInputView").hide();
                    $("#status").hide();
                    $("#preloader").hide();
                    $("#content").show();
                    $("#uploadImage").outerHTML = $("#uploadImage").outerHTML.replace(/(value=\").+\"/i, "$1\"");
                }
            });
            $("#cbShowNick").click(function () {
                if ($("#showNick").attr("checked") == "checked") {
                    $(".qm").html("签名:你猜");
                    $(this).addClass("checkboxcheck");
                } else {
                    $(".qm").html("签名:" + "小日子先生");
                    $(this).removeClass("checkboxcheck");
                }
            });
            $("#lbRec").click(function () {
                $("#friendView").show();
                $("#content").hide();
                $("#friendView a").removeClass("checkbox-one-checked");
            });
            $("#btnSure").click(function () {
                $("#friendView").hide();
                $("#content").show();
            });
            var state = true;
            $("#btnSend").on("touchend", function () {
                $("#btnSend").removeClass("btnprintCheck");
            })
            $("#btnSend").on("touchstart", function () {
                $("#btnSend").addClass("btnprintCheck");
            })
            $("#btnSend").click(function () {
                if (state) {
                    state = false;
                    setTimeout(function () {
                        state = true;
                    }, 5000);

                    var _msg = "";
                    var img = "";
                    $("#imgPrint").html().replace(/<img [^>]*src=['"]([^'"]+)[^>]*>/gi, function (match) {
                        img = match;
                    });
                    if (img != "") {
                        _msg += img;
                    }
                    if ($("#msg").val() != "") {
                        _msg += '<div>' + $("#msg").val() + '</div>';
                    }
                    if (_msg == "") {
                        $("#msg").attr("placeholder", "打印内容不能为空");
                        setTimeout(function () { $("#msg").attr("placeholder", "输入你想对他(她)说的话..."); }, 3000);
                    } else {
                        setTimeout(function () {
                            $("#sendStateText").text("正在努力为你发送中...");
                            $("#loading").show();
                            $("#sendContent").hide();
                        }, 0);
                        var _toUserName = "角落咖啡"
                        var _fromUserName = "小日子先生";
                        var _showNick = $("#showNick").attr("checked") == "checked" ? 0 : 1;
                        var _guid = "a146710def524321bc7325c9b0855214";
                        var _source = '来自微博';
                        var data = {
                            "DataType": "printTable",
                            "msg": _msg,
                            "toUserName": _toUserName,
                            "fromUserName": _fromUserName,
                            "showNick": _showNick,
                            "guid": _guid,
                            "source": _source
                        };
                        var obj = ajaxData(data, null);
                        if (obj != "false") {
                            var _obj = eval(obj);
                            if (_obj != null) {
                                if (_obj[0]["result"] == 2 || _obj[0]["result"] == 1) {
                                        $("#sendStateText").text("已经为你成功发送...");
                                } else {
                                    $("#sendStateText").text("很抱歉发送已失败...");
                                }
                            } else {
                                $("#sendStateText").text("很抱歉发送已失败...");
                            }
                            setTimeout(function () {
                                $("#loading").hide();
                                $("#sendContent").show();
                            }, 3000);
                        } else {
                            window.location.href = "WXShareFailure.aspx";
                        }
                    }
                } else {
                    $("#err").html("操作太过频繁！");
                    $("#err").show();
                    setTimeout(function () { $("#err").html("&nbsp;"); $("#err").hide() }, 3000);
                }
            });
        });
        function ajaxData(_data, _url) {
            if (_url == "" || _url == null) {
                _url = "../ashx/DBInterface.ashx";
            }
            var obj = $.ajax({
                url: _url,
                type: "POST",
                data: _data,
                async: false
            }).responseText;
            return obj;
        }
    </script>
    <div id='wx_pic' style='margin: 0 auto; display: none;'>
        <img src='../APP/images/logpic300.png' />
    </div>
</head>
<body>
    <form method="post" action="Share.aspx?parameter=eyJndWlkIjogImExNDY3MTBkZWY1MjQzMjFiYzczMjVjOWIwODU1MjE0IiwidGltZXN0YW1wIjoiMjAxNi81LzI3IDIyOjM4OjA0IiwiZGF0YSI6eyJuaWNrbmFtZSI6IuWwj-aXpeWtkOWFiOeUnyJ9LCAic2hhcmV0eXBlIjoid2IifQ%3d%3d" id="form1">
<div class="aspNetHidden">
<input type="hidden" name="__VIEWSTATE" id="__VIEWSTATE" value="/wEPDwULLTE4MzYwODA1ODJkZPgGb33WhAD2zZu5dLWNcFoImP8EuzcUEsFxsuF6RYjA" />
</div>

        <div id="preloader">
            <div id="status">
                <p class="center-text">
                    数据加载中...
                </p>
            </div>
        </div>
        <div class="all-elements">
            <div id="content" class="page-content">
                <div id="sendView" class="container">
                    <div class="headimg"></div>
                    <div>
                        <div id="loading" style="display: none">
                            <img id="sendImg" src="../Images/gugu.gif" width="100px" /><div id="sendStateText">正在努力为你发送中...</div>
                        </div>
                        <div id="sendContent" class="formTextareaWrap">
                            <textarea id="msg" class="contactTextarea requiredField" maxlength="3000" placeholder="输入你想对他(她)说的话..." name="contactMessageTextarea"></textarea>
                            <div class="imgview">
                                <label id="imgLable" for="uploadImage" class="toolbtn">
                                    <img id="addImg" state="0" class="addImg" src="/Images/ico_add_picture_unchecked.png" /><input style="display: none;" accept="image/png,image/bmp,image/jpg,image/jpeg" id="uploadImage" name="uploadImage" type="file" />
                                </label>
                            </div>
                        </div>
                        <div id="imgPrint" style="display: none"></div>
                    </div>
                </div>
                <div class="decoration">
                </div>
                <div class="namearea">
                    <div style="width: 95%; margin: 0 auto">
                        <div class="nm">
                            <span style="float: left;">匿名:</span><label id="cbShowNick" for="showNick" class="checkboxuncheck"><input id="showNick" style="float: left; display: none" type="checkbox" /></label>
                        </div>
                        <label class="qm">签名: 小日子先生</label>
                    </div>
                </div>

                <div class="bottom">
                    <div style="width: 100%; height: 0.3vh"></div>
                    <div id="btnSend" class="hm btnprint"></div>
                    <a href="../download/index.aspx?pageType=download" class="downloadpage">
                        <div style="display: block"><span class="link">更好体验立即下载APP</span></div>
                    </a>
                </div>
            </div>
            <div id="imgInputView" class="textInputView">
                <div class="viewhead">
                    <img id="btnReturn" style="float: left; cursor: pointer; width: 30px; margin-top: 5px" src="../Images/btnrtn.png" />
                    <div id="btnClearImg" class="btnInsert hm">删除</div>
                </div>
                <img id="imgView" width="100%" />
            </div>
            <canvas width="384" style="display: none" />
        </div>
        <div id="err" class="err">&nbsp;</div>
    </form>
    <script type="text/javascript">
        $(function () {
            $("#status").hide();
            $(".all-elements").show();
        })
    </script>
</body>
