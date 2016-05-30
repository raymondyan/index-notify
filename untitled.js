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