#ifndef SPRITE_H
#define SPRITE_H

#include <QObject>
#include <QQGraphicsItem>
#include <QTimer>
#include <QPixmap>
#include <QPainter>

class Sprite : public QObject, public QGraphicsItem
{
    Q_OBJECT
public:
    explicit Sprite(QPointF point, QObject *parent = 0);

    enum { Type = UserType + 1 };// меняем тип объекта у взрыва, чтобы пули игнорировали взрывы

    int type() const; // Также переопределяем функцию для получения типа объекта

signals:

public slots:

private slots:
    void nextFrame();   /// Слот для перелистывания кадров

private:
    void paint(QPainter *painter, const QStyleOptionGraphicsItem *option, QWidget *widget);
    QRectF boundingRect() const;

private:
    QTimer *timer;          /// Таймер для анимации взрыва
    QPixmap *spriteImage;   /// QPixmap для спрайта со взрывом
    int currentFrame;     /// Координата текущего кадра в спрайте
    int tileHeight;
    int tileWidth;
    int lastFrame;
    int currentFrameX;
    int currentFrameY;
};

#endif // SPRITE_H
