#pragma once

#include <KDecoration3/Decoration>
#include <KDecoration3/DecorationButton>
#include <QPointer>
#include <QVector>
#include <QVariantList>

class ClockButton;

class ClockDecoration : public KDecoration3::Decoration
{
    Q_OBJECT

public:
    explicit ClockDecoration(QObject *parent = nullptr, const QVariantList &args = QVariantList());

protected:
    bool init() override;
    void paint(QPainter *painter, const QRectF &repaintRegion) override;

private:
    void createButtons();
    void layoutButtons();
    QColor backgroundColor() const;
    QColor foregroundColor() const;
    QString currentTimeString() const;

private:
    QVector<QPointer<ClockButton>> m_buttons;
    int m_titleHeight = 28;
    int m_buttonSize = 20;
    int m_spacing = 6;
};
