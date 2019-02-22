#ifndef PLAYERTANK_H
#define PLAYERTANK_H

#include <QPoint>
#include <QKeyEvent>
#include <QtQuick/QQuickPaintedItem>
class PlayerTank : public QQuickItem{
    Q_OBJECT
    Q_PROPERTY(QString  framePath
               READ  getFramePath
               WRITE setFramePath
               NOTIFY   framePathChanged)
    Q_PROPERTY(int      posCoordX
               READ  getPosCoordX
               WRITE setPosCoordX
               NOTIFY   posCoordXChanged)
    Q_PROPERTY(int      posCoordY
               READ  getPosCoordY
               WRITE setPosCoordY
               NOTIFY   posCoordYChanged)
public:
    PlayerTank();

    QString getFramePath(){return framePath;}
    void    setFramePath(QString frameName);

    int  getPosCoordX(){return posCoordY;}
    void setPosCoordX(int coodrY);

    int  getPosCoordY(){return posCoordX;}
    void setPosCoordY(int coodrX);
    //Q_INVOKABLE int qInvokeExam(QString str);
    Q_INVOKABLE void keyPressEvent(int keyCode);
signals:
    void framePathChanged();
    void posCoordYChanged();
    void posCoordXChanged();


public slots:
   // void callMeQML();

private:

    void nextFrame();
    int posCoordY, posCoordX,
        height, width,
        actualFrame;

    float speed;

    QString imgPath;
    QString framePath;
    QPoint posCoords;

};

#endif // PLAYERTANK_H
