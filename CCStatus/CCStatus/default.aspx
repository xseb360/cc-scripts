<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="default.aspx.cs" Inherits="CCStatus._default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>

    <meta http-equiv="refresh" content="15">
    <style type="text/css">
        #btnClear
        {
            width: 58px;
        }
        
        /* Eric Meyer's Reset CSS v2.0 - http://cssreset.com */
        html,body,div,span,applet,object,iframe,h1,h2,h3,h4,h5,h6,p,blockquote,pre,a,abbr,acronym,address,big,cite,code,del,dfn,em,img,ins,kbd,q,s,samp,small,strike,strong,sub,sup,tt,var,b,u,i,center,dl,dt,dd,ol,ul,li,fieldset,form,label,legend,table,caption,tbody,tfoot,thead,tr,th,td,article,aside,canvas,details,embed,figure,figcaption,footer,header,hgroup,menu,nav,output,ruby,section,summary,time,mark,audio,video{border:0;font-size:100%;font:inherit;vertical-align:baseline;margin:0;padding:0}article,aside,details,figcaption,figure,footer,header,hgroup,menu,nav,section{display:block}body{line-height:1}ol,ul{list-style:none}blockquote,q{quotes:none}blockquote:before,blockquote:after,q:before,q:after{content:none}table{border-collapse:collapse;border-spacing:0}
    </style>
</head>
<body style="background-color:Black; color:Silver; font-family:Courier New; white-space:pre">
    <form id="form1" runat="server">
    <div>
        <asp:Label ID="lblOutput" Text="" runat="server"></asp:Label>
    </div>
    <div>
        <asp:Label ID="Label2" Text="&gt; _" runat="server"></asp:Label>
    </div>
    <div>
        <asp:Button ID="btnClear" runat="server" Text="clear offline" onclick="btnClear_Click"></asp:Button>
    </div>
    </form>
</body>
</html>
