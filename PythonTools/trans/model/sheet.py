
import gspread
from oauth2client.service_account import ServiceAccountCredentials as sac
import os
import csv

scope = ['https://spreadsheets.google.com/feeds',
         'https://www.googleapis.com/auth/drive']

cr = sac.from_json_keyfile_name('Auth/auth.json', scope)  
gs = gspread.authorize(cr)
sh = gs.open('KKPortal-Translation') 
wks = sh.worksheet('translation')

# 將 Google Spreadsheet 檔案載下來, 存到本地端 csv 檔, 會拉下來本地再操作, 原因是若直接操作 wks 多次, 會收到 HTTP 429 Error (請求次數過於平繁)

with open("translation.csv", 'w', newline='') as f:
    writer = csv.writer(f)
    writer.writerows(wks.get_all_values())

# 新增存放翻譯檔的資料夾
dirName = "Localizations"

if not os.path.exists(dirName):
    os.mkdir("Localizations")
    print("Directory " , dirName ,  " Created ")
else:    
    print("Directory " , dirName ,  " Already exists")

with open("translation.csv", "r") as f:
    r = csv.reader(f, delimiter=",")
    
    for i, row in enumerate(r):

        for j, item in enumerate(row):

            if i != 0 and j != 0:
                
                if j == 1:
                    file = open(f"Localizations/en_localization.strings", "a")
                    if item == "":
                        file.write("\n")
                    else:
                        file.write(f"\"{row[0]}\" = \"{item}\";\n")

                elif j == 2:
                    file = open(f"Localizations/zh-Hant_localization.strings", "a")
                    if item == "":
                        file.write("\n")
                    else:
                        file.write(f"\"{row[0]}\" = \"{item}\";\n")

                elif j == 3:
                    file = open(f"Localizations/zh-HK_localization.strings", "a")
                    if item == "":
                        file.write("\n")
                    else:
                        file.write(f"\"{row[0]}\" = \"{item}\";\n")

                elif j == 4:
                    file = open(f"Localizations/zh-Hans_localization.strings", "a")
                    if item == "":
                        file.write("\n")
                    else:
                        file.write(f"\"{row[0]}\" = \"{item}\";\n")

                elif j == 5:
                    file = open(f"Localizations/ja_localization.strings", "a")
                    if item == "":
                        file.write("\n")
                    else:
                        file.write(f"\"{row[0]}\" = \"{item}\";\n")

                elif j == 6:
                    file = open(f"Localizations/ko_localization.strings", "a")
                    if item == "":
                        file.write("\n")
                    else:
                        file.write(f"\"{row[0]}\" = \"{item}\";\n")

                elif j == 7:
                    file = open(f"Localizations/vi_localization.strings", "a")
                    if item == "":
                        file.write("\n")
                    else:
                        file.write(f"\"{row[0]}\" = \"{item}\";\n")

                elif j == 8:
                    file = open(f"Localizations/th_localization.strings", "a")
                    if item == "":
                        file.write("\n")
                    else:
                        file.write(f"\"{row[0]}\" = \"{item}\";\n")

                else:
                    break
