Add-Type -AssemblyName System.Drawing

$notice = 'C:\KnightOnline\Server\launcher_notice.html'
$bg = 'C:\KnightOnline\Client\AkGame\Launcher\background.png'
$clean = 'C:\KnightOnline\Client\AkGame\Launcher\background_clean.png'

if (!(Test-Path -LiteralPath $clean)) {
  Copy-Item -LiteralPath $bg -Destination $clean -Force
}

Copy-Item -LiteralPath $clean -Destination $bg -Force

function Get-LauncherLines {
  $html = Get-Content -LiteralPath $notice -Encoding UTF8
  $items = New-Object System.Collections.Generic.List[object]

  foreach ($line in $html) {
    if ($line -notmatch 'data-launcher-line') { continue }

    $icon = 'dot'
    if ($line -match 'data-icon="star"') { $icon = 'star' }
    elseif ($line -match 'data-icon="alert"') { $icon = 'alert' }
    elseif ($line -match 'data-icon="event"') { $icon = 'event' }
    elseif ($line -match 'data-icon="gift"') { $icon = 'gift' }
    elseif ($line -match 'data-icon="shield"') { $icon = 'shield' }
    elseif ($line -match 'data-icon="discord"') { $icon = 'discord' }

    $text = ($line -replace '<[^>]+>', '').Trim()
    $text = [System.Net.WebUtility]::HtmlDecode($text)
    if ($text) {
      $items.Add([pscustomobject]@{ Icon = $icon; Text = $text })
    }
  }

  return $items
}

function Draw-NoticeIcon {
  param(
    [System.Drawing.Graphics]$Graphics,
    [string]$Icon,
    [float]$X,
    [float]$Y
  )

  $gold = [System.Drawing.Color]::FromArgb(255, 226, 184, 104)
  $red = [System.Drawing.Color]::FromArgb(255, 190, 45, 48)
  $green = [System.Drawing.Color]::FromArgb(255, 64, 185, 95)
  $blue = [System.Drawing.Color]::FromArgb(255, 82, 146, 230)
  $dark = [System.Drawing.Color]::FromArgb(210, 20, 9, 10)
  $penGold = New-Object System.Drawing.Pen($gold, 1.6)
  $penRed = New-Object System.Drawing.Pen($red, 1.6)
  $penGreen = New-Object System.Drawing.Pen($green, 1.6)
  $fillDark = New-Object System.Drawing.SolidBrush($dark)
  $fillGold = New-Object System.Drawing.SolidBrush($gold)
  $fillRed = New-Object System.Drawing.SolidBrush($red)
  $fillGreen = New-Object System.Drawing.SolidBrush($green)
  $fillBlue = New-Object System.Drawing.SolidBrush($blue)
  $font = New-Object System.Drawing.Font('Verdana', 7.5, [System.Drawing.FontStyle]::Bold)
  $fmt = New-Object System.Drawing.StringFormat
  $fmt.Alignment = [System.Drawing.StringAlignment]::Center
  $fmt.LineAlignment = [System.Drawing.StringAlignment]::Center

  $r = [System.Drawing.RectangleF]::new($X, $Y + 2, 17, 17)
  $Graphics.FillEllipse($fillDark, $r)

  switch ($Icon) {
    'star' {
      $Graphics.DrawEllipse($penGold, $r)
      $Graphics.DrawString('*', $font, $fillGold, $r, $fmt)
    }
    'alert' {
      $Graphics.DrawEllipse($penRed, $r)
      $Graphics.DrawString('!', $font, $fillRed, $r, $fmt)
    }
    'event' {
      $Graphics.DrawRectangle($penGreen, $X + 2, $Y + 4, 13, 12)
      $Graphics.DrawLine($penGreen, $X + 2, $Y + 8, $X + 15, $Y + 8)
      $Graphics.DrawString('E', $font, $fillGreen, $r, $fmt)
    }
    'gift' {
      $Graphics.DrawRectangle($penGold, $X + 2, $Y + 6, 13, 10)
      $Graphics.DrawLine($penGold, $X + 8.5, $Y + 6, $X + 8.5, $Y + 16)
      $Graphics.DrawLine($penGold, $X + 2, $Y + 10, $X + 15, $Y + 10)
    }
    'shield' {
      $pts = @(
        [System.Drawing.PointF]::new($X + 8.5, $Y + 3),
        [System.Drawing.PointF]::new($X + 15, $Y + 6),
        [System.Drawing.PointF]::new($X + 13, $Y + 14),
        [System.Drawing.PointF]::new($X + 8.5, $Y + 18),
        [System.Drawing.PointF]::new($X + 4, $Y + 14),
        [System.Drawing.PointF]::new($X + 2, $Y + 6)
      )
      $Graphics.DrawPolygon($penGreen, $pts)
    }
    'discord' {
      $Graphics.DrawEllipse((New-Object System.Drawing.Pen($blue, 1.6)), $r)
      $Graphics.DrawString('D', $font, $fillBlue, $r, $fmt)
    }
    default {
      $Graphics.FillEllipse($fillGold, [System.Drawing.RectangleF]::new($X + 6, $Y + 8, 5, 5))
    }
  }

  $penGold.Dispose()
  $penRed.Dispose()
  $penGreen.Dispose()
  $fillDark.Dispose()
  $fillGold.Dispose()
  $fillRed.Dispose()
  $fillGreen.Dispose()
  $fillBlue.Dispose()
  $font.Dispose()
  $fmt.Dispose()
}

$items = Get-LauncherLines

$bmp = [System.Drawing.Bitmap]::FromFile($bg)
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
$g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit

$titleFont = New-Object System.Drawing.Font('Verdana', 14, [System.Drawing.FontStyle]::Bold)
$lineFont = New-Object System.Drawing.Font('Verdana', 10, [System.Drawing.FontStyle]::Bold)
$gold = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 226, 184, 104))
$white = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 245, 238, 218))
$shadow = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(190, 0, 0, 0))
$muted = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 213, 190, 154))

$titleFmt = New-Object System.Drawing.StringFormat
$titleFmt.Alignment = [System.Drawing.StringAlignment]::Center
$titleFmt.LineAlignment = [System.Drawing.StringAlignment]::Center

$lineFmt = New-Object System.Drawing.StringFormat
$lineFmt.Alignment = [System.Drawing.StringAlignment]::Near
$lineFmt.LineAlignment = [System.Drawing.StringAlignment]::Near
$lineFmt.Trimming = [System.Drawing.StringTrimming]::Word

$titleRect = [System.Drawing.RectangleF]::new(650, 102, 420, 28)
$shadowTitle = [System.Drawing.RectangleF]::new(652, 104, 420, 28)
$g.DrawString('AK KO DUYURULAR', $titleFont, $shadow, $shadowTitle, $titleFmt)
$g.DrawString('AK KO DUYURULAR', $titleFont, $gold, $titleRect, $titleFmt)

$y = 143.0
$bottom = 438.0
$left = 662.0
$iconX = 666.0
$textX = 690.0
$textW = 360.0

for ($i = 0; $i -lt $items.Count; $i++) {
  if ($y -ge $bottom) { break }

  $item = $items[$i]
  $rect = [System.Drawing.RectangleF]::new($textX, $y, $textW, 46)
  $measure = $g.MeasureString($item.Text, $lineFont, [System.Drawing.SizeF]::new($textW, 80), $lineFmt)
  $rowH = [Math]::Max(24, [Math]::Ceiling($measure.Height) + 5)
  if ($y + $rowH -gt $bottom) { break }

  Draw-NoticeIcon -Graphics $g -Icon $item.Icon -X $iconX -Y ($y - 1)

  $drawBrush = if ($i -eq 0) { $gold } else { $white }
  $shadowRect = [System.Drawing.RectangleF]::new($textX + 1.5, $y + 1.5, $textW, $rowH)
  $textRect = [System.Drawing.RectangleF]::new($textX, $y, $textW, $rowH)
  $g.DrawString($item.Text, $lineFont, $shadow, $shadowRect, $lineFmt)
  $g.DrawString($item.Text, $lineFont, $drawBrush, $textRect, $lineFmt)

  $y += $rowH + 5
}

if ($items.Count -eq 0) {
  $emptyRect = [System.Drawing.RectangleF]::new($left, 150, 390, 30)
  $g.DrawString('Duyuru bulunamadi.', $lineFont, $muted, $emptyRect, $lineFmt)
}

$titleFmt.Dispose()
$lineFmt.Dispose()
$gold.Dispose()
$white.Dispose()
$shadow.Dispose()
$muted.Dispose()
$titleFont.Dispose()
$lineFont.Dispose()
$g.Dispose()

$tmp = "$bg.tmp"
$bmp.Save($tmp, [System.Drawing.Imaging.ImageFormat]::Png)
$bmp.Dispose()
Move-Item -LiteralPath $tmp -Destination $bg -Force

Write-Host "Launcher duyurusu guncellendi: $bg"
