import matplotlib.pyplot as plt
import networkx as nx
from networkx.drawing.nx_pydot import graphviz_layout

# ========== ВСТАВИТЬ ЭТОТ КОД ДЛЯ ПОЛУЧЕНИЯ КАРТИНКИ ==========

# Создаем граф
G = nx.DiGraph()

# Уровень 0: Начальное решение
G.add_node("Start", label="Начало", shape="ellipse", color="black")

# Уровень 1: Решение о заказе прогноза
G.add_node("Order_Forecast", label="Заказать прогноз?\n(Стоимость = X)", shape="box", color="blue")
G.add_node("No_Forecast", label="Не заказывать прогноз", shape="box", color="blue")

G.add_edge("Start", "Order_Forecast", label="Да")
G.add_edge("Start", "No_Forecast", label="Нет")

# Уровень 2A: После заказа прогноза - возможные прогнозы
G.add_node("Forecast_Rise", label="Прогноз: 'Рост цен'\nP(F1)=0.62", shape="diamond", color="orange")
G.add_node("Forecast_Stable", label="Прогноз: 'Стабильность'\nP(F2)=0.38", shape="diamond", color="orange")

G.add_edge("Order_Forecast", "Forecast_Rise", label="0.62")
G.add_edge("Order_Forecast", "Forecast_Stable", label="0.38")

# Уровень 2B: Без прогноза - сразу выбор автопарка
G.add_node("Choose_A_NoF", label="Выбор: Дизели (А)", shape="box", color="green")
G.add_node("Choose_B_NoF", label="Выбор: Гибриды (Б)", shape="box", color="green")

G.add_edge("No_Forecast", "Choose_A_NoF", label="Выбрать А")
G.add_edge("No_Forecast", "Choose_B_NoF", label="Выбрать Б")

# Уровень 3A: После прогноза "Рост" - выбор автопарка
G.add_node("Choose_A_after_F1", label="Выбор: Дизели (А)", shape="box", color="green")
G.add_node("Choose_B_after_F1", label="Выбор: Гибриды (Б)", shape="box", color="green")

G.add_edge("Forecast_Rise", "Choose_A_after_F1", label="Выбрать А")
G.add_edge("Forecast_Rise", "Choose_B_after_F1", label="Выбрать Б")

# Уровень 3B: После прогноза "Стабильность" - выбор автопарка
G.add_node("Choose_A_after_F2", label="Выбор: Дизели (А)", shape="box", color="green")
G.add_node("Choose_B_after_F2", label="Выбор: Гибриды (Б)", shape="box", color="green")

G.add_edge("Forecast_Stable", "Choose_A_after_F2", label="Выбрать А")
G.add_edge("Forecast_Stable", "Choose_B_after_F2", label="Выбрать Б")

# Уровень 4: Сценарии цен (листья дерева с прибылями)

# После "Нет прогноза" -> Выбрали А
G.add_node("S1_A_NoF", label="Сценарий: Рост\nP=0.6\nПрибыль=150", shape="ellipse", color="red")
G.add_node("S2_A_NoF", label="Сценарий: Стабильность\nP=0.4\nПрибыль=600", shape="ellipse", color="red")
G.add_edge("Choose_A_NoF", "S1_A_NoF", label="0.6")
G.add_edge("Choose_A_NoF", "S2_A_NoF", label="0.4")

# После "Нет прогноза" -> Выбрали Б
G.add_node("S1_B_NoF", label="Сценарий: Рост\nP=0.6\nПрибыль=450", shape="ellipse", color="red")
G.add_node("S2_B_NoF", label="Сценарий: Стабильность\nP=0.4\nПрибыль=350", shape="ellipse", color="red")
G.add_edge("Choose_B_NoF", "S1_B_NoF", label="0.6")
G.add_edge("Choose_B_NoF", "S2_B_NoF", label="0.4")

# После прогноза "Рост" -> Выбрали А (с учетом апостериорных вероятностей)
G.add_node("S1_A_F1", label="Сценарий: Рост\nP=0.871\nПрибыль=150", shape="ellipse", color="red")
G.add_node("S2_A_F1", label="Сценарий: Стабильность\nP=0.129\nПрибыль=600", shape="ellipse", color="red")
G.add_edge("Choose_A_after_F1", "S1_A_F1", label="0.871")
G.add_edge("Choose_A_after_F1", "S2_A_F1", label="0.129")

# После прогноза "Рост" -> Выбрали Б
G.add_node("S1_B_F1", label="Сценарий: Рост\nP=0.871\nПрибыль=450", shape="ellipse", color="red")
G.add_node("S2_B_F1", label="Сценарий: Стабильность\nP=0.129\nПрибыль=350", shape="ellipse", color="red")
G.add_edge("Choose_B_after_F1", "S1_B_F1", label="0.871")
G.add_edge("Choose_B_after_F1", "S2_B_F1", label="0.129")

# После прогноза "Стабильность" -> Выбрали А
G.add_node("S1_A_F2", label="Сценарий: Рост\nP=0.158\nПрибыль=150", shape="ellipse", color="red")
G.add_node("S2_A_F2", label="Сценарий: Стабильность\nP=0.842\nПрибыль=600", shape="ellipse", color="red")
G.add_edge("Choose_A_after_F2", "S1_A_F2", label="0.158")
G.add_edge("Choose_A_after_F2", "S2_A_F2", label="0.842")

# После прогноза "Стабильность" -> Выбрали Б
G.add_node("S1_B_F2", label="Сценарий: Рост\nP=0.158\nПрибыль=450", shape="ellipse", color="red")
G.add_node("S2_B_F2", label="Сценарий: Стабильность\nP=0.842\nПрибыль=350", shape="ellipse", color="red")
G.add_edge("Choose_B_after_F2", "S1_B_F2", label="0.158")
G.add_edge("Choose_B_after_F2", "S2_B_F2", label="0.842")

# Визуализация
plt.figure(figsize=(20, 12))

# Используем graphviz для иерархического расположения
pos = graphviz_layout(G, prog='dot')

# Рисуем узлы
node_colors = []
for node in G.nodes():
    if 'ellipse' in G.nodes[node].get('shape', ''):
        node_colors.append('lightcoral')
    elif 'box' in G.nodes[node].get('shape', ''):
        node_colors.append('lightblue')
    elif 'diamond' in G.nodes[node].get('shape', ''):
        node_colors.append('lightgreen')
    else:
        node_colors.append('lightgray')

nx.draw(G, pos, with_labels=True, 
        labels={n: G.nodes[n].get('label', n) for n in G.nodes()},
        node_color=node_colors,
        node_shape='s',
        font_size=9,
        font_weight='bold',
        edge_color='gray',
        arrowsize=15)

# Рисуем метки на ребрах
edge_labels = nx.get_edge_attributes(G, 'label')
nx.draw_networkx_edge_labels(G, pos, edge_labels=edge_labels, font_size=8)

plt.title("Дерево решений: Выбор автопарка с возможностью заказа прогноза", fontsize=14, fontweight='bold')
plt.axis('off')
plt.tight_layout()

# Сохраняем и показываем
plt.savefig("decision_tree_autopark.png", dpi=300, bbox_inches='tight')
plt.show()

# ========== КОНЕЦ КОДА ДЛЯ ГЕНЕРАЦИИ КАРТИНКИ ==========
