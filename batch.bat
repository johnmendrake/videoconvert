ffmpeg -i ".\a.ts" -c:v libx265 -s 720x576 -aspect 16:9 -c:a ac3 -preset medium -crf 15 ".\a.mkv"
ffmpeg -i ".\b.ts" -c:v libx265 -s 720x576 -aspect 16:9 -c:a ac3 -preset medium -crf 15 ".\b.mkv"
ffmpeg -i ".\foo\c.ts" -c:v libx265 -s 720x576 -aspect 16:9 -c:a ac3 -preset medium -crf 15 ".\foo\c.mkv"
