#include "sprite.h"


//у каждого спрайта должно быть свой диапазон воспроизведения(участок для вывода) координаты от и до
//и колво кадров.

Sprite::Sprite(QPointF point, QObject *parent)
              :QObject(parent), QGraphicsItem(){
    this->setPos(point);    // Устанавливаем позицию взрыва
    currentFrameX = 0;       // Координата текущего кадра спрайта
    currentFrameY = 0;       // Координата текущего кадра спрайта
    spriteImage = new QPixmap(":/sprites/sprite_sheet.png"); // Загружаем спрайт в QPixmap

    tileHeight = 20;
    tileWidth  = 20;
    lastFrame = 300;

    timer = new QTimer();   // Создаём таймер для анимации спрайта
   // connect(timer, &QTimer::timeout,
   //         this , &Sprite::nextFrame);// перелистывание кадров спрайта
    timer->start(25);   // Запускаем спрайт на генерацию сигнала с периодичность 25 мс
    //timer->stop();
}
QRectF Sprite::boundingRect() const{
    return QRectF(-10, -10, 20, 20); //left, top, width, height
}
void Sprite::paint(QPainter *painter,
                   const QStyleOptionGraphicsItem *option,
                   QWidget *widget){
    /* В отрисовщике графического объекта отрисовываем спрайт
     * Разберём все параметры данной функции
     * Первых два аргумента - это координат X и Y куда помещается QPixmap
     * Третий аргумент - это указатель на QPixmap
     * 4 и 5 аргументы - Координаты в В изображении QPixmap, откуда будет отображаться изображение
     * Задавая координату X с помощью перемнной currentFrame мы будем как бы передвигать камеру
     * по спрайту
     * и последние два аргумента - это ширина и высота отображаем части изображение, то есть кадра
     * */
           //drawPixmap(
    painter->drawPixmap(-(tileWidth/2),    //int x,
                        -(tileHeight/2),  // int y,
                        *spriteImage,    //  const QPixmap &pixmap,
                        currentFrameX,  //   int sx,
                        currentFrameY, //    int sy,
                        tileWidth,    //     int sw,
                        tileHeight); //      int sh)   // Отрисовываем один из кадров взрыва
    Q_UNUSED(option);
    Q_UNUSED(widget);
}
void Sprite::nextFrame(){
    currentFrameX += tileWidth;                  // Выбораем следующий кадр двигая координату X
    if (currentFrameX >= lastFrame){           // Если кадры кончились,
        this->deleteLater();           //  удаляем объект взрыва
    }else{                            // иначе продолжаем кадровую последовательность
        this->update(-(tileWidth/2), -(tileHeight/2),//DrawCoord
                       tileWidth,      tileHeight); // DrawSize показывая следующий кадр
    }
}
int Sprite::type() const {return Type;} // Возвращаем тип объекта
