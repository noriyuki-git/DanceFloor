/*
  Dance floor
  
    1st Feb 2025 - Noriyuki Suzuki
    
  Music track:
    https://pixabay.com/ja/music/summer-party-157615/
    Summer Party (Top-Flow)
 */

import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioPlayer player;
FFT fft;

int numX = 15;     // number of squares in one row. Must be an odd number.
int numY = 11;     // number of squares in one col. Must be an odd number.
int box_gap = 64;   // gap width
boolean loop = false;  // ループ再生

void setup() {
  // fullScreen();

  size(1024, 768); // Screen size
  
  background(0);
  noStroke();
  rectMode(CENTER);

  // Minimオブジェクトの初期化
  minim = new Minim(this);

  // MP3ファイルの読み込み (ファイル名は適宜変更してください)
  player = minim.loadFile("summer-party-157615.mp3", 1024);
  player.play();
  if ( loop ) {
    player.loop();
  }

  // FFTオブジェクトの初期化
  fft = new FFT(player.bufferSize(), player.sampleRate());
}

void draw() {
  int d;
  int cx, cy;
  int box_size;
  int left_margin, top_margin;

  background(0);
  fft.forward(player.mix);

  // センターにあるBOXの座標
  cx = floor(numX/2);
  cy = floor(numY/2);

  // 各BOXの辺の長さ
  box_size = min( (height-(box_gap * (numY+1)))/numY, (width-(box_gap * (numX+1)))/numX);

  // 余白の幅
  left_margin = ( width - (numX*box_size) - ((numX+1)*box_gap) ) / 2;
  top_margin = ( height - (numY*box_size) - ((numY+1)*box_gap) ) / 2;

  for (int row = 0; row < numY; row++) {
    for (int col = 0; col < numX; col++) {

      //センターからの距離
      d = max(abs(col-cx), abs(row-cy));

      // FFT結果の取得
      float amplitude = fft.getBand(d);

      // 色変化のための値設定
      float colorValue = map(amplitude, 0, 50, 0, 255);
      float alpha = min(255, map(d, 0, max(numX-cx, numY-cy), 32, 700));
      fill(colorValue, 255 - colorValue, 150, alpha);

      // 四角形描画
      int bx = col * (box_size + box_gap) + (box_size/2 + box_gap) + left_margin;
      int by = row * (box_size + box_gap) + (box_size/2 + box_gap) + top_margin;
      int bw = (int)map(amplitude, 0, 128, box_size, box_size+(box_gap/2));
      rect(bx, by, bw, bw);
    }
  }
}

void stop() {
  player.close();
  minim.stop();
  super.stop();
}
