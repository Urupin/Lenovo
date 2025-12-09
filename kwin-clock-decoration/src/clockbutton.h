#pragma once

#include <KDecoration3/DecorationButton>
#include <QColor>

class ClockButton : public KDecoration3::DecorationButton
{
    Q_OBJECT

public:
    ClockButton(KDecoration3::DecorationButtonType type, KDecoration3::Decoration *decoration, QObject *parent = nullptr);

    void paint(QPainter *painter, const QRectF &repaintRegion) override;

    void setSize(int size);
    int size() const { return m_size; }

private:
    void paintSymbol(QPainter *painter, const QRectF &buttonRect);

private:
    int m_size = 20;
    QColor m_activeColor = QColor("#f5f5f5");
    QColor m_inactiveColor = QColor("#c1c7d0");
    QColor m_hoverColor = QColor("#7aa2f7");
    QColor m_closeColor = QColor("#e06c75");
};
