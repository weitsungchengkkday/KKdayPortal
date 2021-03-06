# KKdayPortal

## 簡介
對外, 做為開源軟體 Plone 的使用介面, 供外部使用者讀取個人 Plone 網站資源。\
對內, 作為公司內部入口APP, 讀取公司 Plone  網站資源, 與連接不同服務系統。

## 登入流程

### 外部使用者
輸入config 檔網址, 讀取 Plone 網頁位置, 與登入帳號與密碼, 即可登入

### KKday 同仁
在輸入網頁的欄位中輸入 KKPortal, 即可藉由 Google SAML 流程登入 

由於 Mobile APP 無法直接使用 Google SAML 服務, 所以 APP SAML 登入將透過 WKWebView 完成, 以取得的 SAML Token。 再透過 SAML Token 和 Plone 後台換得 Plone Restful API token。

SAML 登入流程圖:
![image](https://github.com/weitsungchengkkday/KKdayPortal/blob/master/Plone_SAML_Flow.png)

## Services 資訊取得流程

![image](https://github.com/weitsungchengkkday/KKdayPortal/blob/master/DataLoadFlow.png)
