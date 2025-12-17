import matplotlib.pyplot as plt
import networkx as nx

# ========== ИСПРАВЛЕННЫЙ КОД БЕЗ PYDOT ==========

# Создаем граф
G = nx.DiGraph()

# Добавляем узлы с атрибутами для форматирования
nodes = [
    ("Start", {"label": "Начало", "pos": (0, 0)}),
    
    # Решение о прогнозе
    ("Order_Forecast", {"label": "Заказать прогноз?\n(Стоимость = X)", "pos": (-2, -2)}),
    ("No_Forecast", {"label": "Не заказывать\nпрогноз", "pos": (2, -2)}),
    
    # Прогнозы
    ("Forecast_Rise", {"label": "Прогноз: 'Рост цен'\nP(F1)=0.62", "pos": (-3, -4)}),
    ("Forecast_Stable", {"label": "Прогноз: 'Стабильность'\nP(F2)=0.38", "pos": (-1, -4)}),
    
    # Решения без прогноза
    ("Choose_A_NoF", {"label": "Выбор:\nДизели (А)", "pos": (1, -4)}),
    ("Choose_B_NoF", {"label": "Выбор:\nГибриды (Б)", "pos": (3, -4)}),
    
    # Решения после прогноза "Рост"
    ("Choose_A_after_F1", {"label": "Выбор:\nДизели (А)", "pos": (-4, -6)}),
    ("Choose_B_after_F1", {"label": "Выбор:\nГибриды (Б)", "pos": (-2, -6)}),
    
    # Решения после прогноза "Стабильность"
    ("Choose_A_after_F2", {"label": "Выбор:\nДизели (А)", "pos": (0, -6)}),
    ("Choose_B_after_F2", {"label": "Выбор:\nГибриды (Б)", "pos": (2, -6)}),
]

# Добавляем узлы
for node, attrs in nodes:
    G.add_node(node, **attrs)

# Добавляем ребра с метками
edges = [
    # От начального решения
    ("Start", "Order_Forecast", {"label": "Да"}),
    ("Start", "No_Forecast", {"label": "Нет"}),
    
    # Прогнозы
    ("Order_Forecast", "Forecast_Rise", {"label": "0.62"}),
    ("Order_Forecast", "Forecast_Stable", {"label": "0.38"}),
    
    # Решения без прогноза
    ("No_Forecast", "Choose_A_NoF", {"label": "Выбрать А"}),
    ("No_Forecast", "Choose_B_NoF", {"label": "Выбрать Б"}),
    
    # Решения после прогноза "Рост"
    ("Forecast_Rise", "Choose_A_after_F1", {"label": "Выбрать А"}),
    ("Forecast_Rise", "Choose_B_after_F1", {"label": "Выбрать Б"}),
    
    # Решения после прогноза "Стабильность"
    ("Forecast_Stable", "Choose_A_after_F2", {"label": "Выбрать А"}),
    ("Forecast_Stable", "Choose_B_after_F2", {"label": "Выбрать Б"}),
]

# Добавляем конечные узлы (листья) для каждой ветки
leaf_nodes = []
leaf_counter = 0

# Функция для добавления листьев
def add_leaf_path(parent_node, scenario_probs, profits_A, profits_B, x_offset):
    global leaf_counter
    
    # Листья для выбора А
    leaf_A1 = f"Leaf_{leaf_counter}"
    leaf_counter += 1
    G.add_node(leaf_A1, label=f"Рост цен\nP={scenario_probs[0]}\nПрибыль={profits_A[0]}", pos=(x_offset, -8))
    G.add_edge(parent_node + "_A", leaf_A1, label=str(scenario_probs[0]))
    
    leaf_A2 = f"Leaf_{leaf_counter}"
    leaf_counter += 1
    G.add_node(leaf_A2, label=f"Стабильность\nP={scenario_probs[1]}\nПрибыль={profits_A[1]}", pos=(x_offset+1, -8))
    G.add_edge(parent_node + "_A", leaf_A2, label=str(scenario_probs[1]))
    
    # Листья для выбора Б
    leaf_B1 = f"Leaf_{leaf_counter}"
    leaf_counter += 1
    G.add_node(leaf_B1, label=f"Рост цен\nP={scenario_probs[0]}\nПрибыль={profits_B[0]}", pos=(x_offset+2, -8))
    G.add_edge(parent_node + "_B", leaf_B1, label=str(scenario_probs[0]))
    
    leaf_B2 = f"Leaf_{leaf_counter}"
    leaf_counter += 1
    G.add_node(leaf_B2, label=f"Стабильность\nP={scenario_probs[1]}\nПрибыль={profits_B[1]}", pos=(x_offset+3, -8))
    G.add_edge(parent_node + "_B", leaf_B2, label=str(scenario_probs[1]))

# Добавляем все ребра
for src, dst, attrs in edges:
    G.add_edge(src, dst, **attrs)

# Создаем узлы для конечных решений (А и Б варианты)
# и соединяем их с листьями

# 1. Без прогноза - Выбор А
G.add_node("Choose_A_NoF_A", label="", pos=(0.5, -6))
G.add_edge("Choose_A_NoF", "Choose_A_NoF_A", label="")

# 2. Без прогноза - Выбор Б  
G.add_node("Choose_A_NoF_B", label="", pos=(3.5, -6))
G.add_edge("Choose_B_NoF", "Choose_A_NoF_B", label="")

# 3. После прогноза "Рост" - Выбор А
G.add_node("Choose_A_F1_A", label="", pos=(-4.5, -8))
G.add_edge("Choose_A_after_F1", "Choose_A_F1_A", label="")

# 4. После прогноза "Рост" - Выбор Б
G.add_node("Choose_A_F1_B", label="", pos=(-1.5, -8))
G.add_edge("Choose_B_after_F1", "Choose_A_F1_B", label="")

# 5. После прогноза "Стабильность" - Выбор А
G.add_node("Choose_A_F2_A", label="", pos=(-0.5, -8))
G.add_edge("Choose_A_after_F2", "Choose_A_F2_A", label="")

# 6. После прогноза "Стабильность" - Выбор Б
G.add_node("Choose_A_F2_B", label="", pos=(2.5, -8))
G.add_edge("Choose_B_after_F2", "Choose_A_F2_B", label="")

# Создаем листья
leaf_positions = {
    # Без прогноза, выбор А: [P(S1)=0.6, P(S2)=0.4], прибыли А: [150, 600]
    "Choose_A_NoF_A": {"probs": [0.6, 0.4], "profits_A": [150, 600], "profits_B": [450, 350], "x": -2},
    
    # Без прогноза, выбор Б: те же вероятности, но прибыли Б
    "Choose_A_NoF_B": {"probs": [0.6, 0.4], "profits_A": [150, 600], "profits_B": [450, 350], "x": 2},
    
    # После F1, выбор А: [P(S1|F1)=0.871, P(S2|F1)=0.129]
    "Choose_A_F1_A": {"probs": [0.871, 0.129], "profits_A": [150, 600], "profits_B": [450, 350], "x": -6},
    
    # После F1, выбор Б
    "Choose_A_F1_B": {"probs": [0.871, 0.129], "profits_A": [150, 600], "profits_B": [450, 350], "x": -4},
    
    # После F2, выбор А: [P(S1|F2)=0.158, P(S2|F2)=0.842]
    "Choose_A_F2_A": {"probs": [0.158, 0.842], "profits_A": [150, 600], "profits_B": [450, 350], "x": -0},
    
    # После F2, выбор Б
    "Choose_A_F2_B": {"probs": [0.158, 0.842], "profits_A": [150, 600], "profits_B": [450, 350], "x": 4},
}

# Упрощаем: создаем конечные узлы напрямую
final_outcomes = [
    # Без прогноза, Выбор А
    ("S1_A_NoF", "Рост (P=0.6)\nПрибыль=150", (0, -8)),
    ("S2_A_NoF", "Стабильность (P=0.4)\nПрибыль=600", (1, -8)),
    
    # Без прогноза, Выбор Б
    ("S1_B_NoF", "Рост (P=0.6)\nПрибыль=450", (2.5, -8)),
    ("S2_B_NoF", "Стабильность (P=0.4)\nПрибыль=350", (3.5, -8)),
    
    # После F1, Выбор А
    ("S1_A_F1", "Рост (P=0.871)\nПрибыль=150", (-4.5, -10)),
    ("S2_A_F1", "Стабильность (P=0.129)\nПрибыль=600", (-3.5, -10)),
    
    # После F1, Выбор Б
    ("S1_B_F1", "Рост (P=0.871)\nПрибыль=450", (-1.5, -10)),
    ("S2_B_F1", "Стабильность (P=0.129)\nПрибыль=350", (-0.5, -10)),
    
    # После F2, Выбор А
    ("S1_A_F2", "Рост (P=0.158)\nПрибыль=150", (0.5, -10)),
    ("S2_A_F2", "Стабильность (P=0.842)\nПрибыль=600", (1.5, -10)),
    
    # После F2, Выбор Б
    ("S1_B_F2", "Рост (P=0.158)\nПрибыль=450", (3, -10)),
    ("S2_B_F2", "Стабильность (P=0.842)\nПрибыль=350", (4, -10)),
]

for node_id, label, position in final_outcomes:
    G.add_node(node_id, label=label, pos=position)

# Соединяем решения с исходами
connections = [
    # Без прогноза
    ("Choose_A_NoF", "S1_A_NoF", "0.6"),
    ("Choose_A_NoF", "S2_A_NoF", "0.4"),
    ("Choose_B_NoF", "S1_B_NoF", "0.6"),
    ("Choose_B_NoF", "S2_B_NoF", "0.4"),
    
    # После F1
    ("Choose_A_after_F1", "S1_A_F1", "0.871"),
    ("Choose_A_after_F1", "S2_A_F1", "0.129"),
    ("Choose_B_after_F1", "S1_B_F1", "0.871"),
    ("Choose_B_after_F1", "S2_B_F1", "0.129"),
    
    # После F2
    ("Choose_A_after_F2", "S1_A_F2", "0.158"),
    ("Choose_A_after_F2", "S2_A_F2", "0.842"),
    ("Choose_B_after_F2", "S1_B_F2", "0.158"),
    ("Choose_B_after_F2", "S2_B_F2", "0.842"),
]

for src, dst, label in connections:
    G.add_edge(src, dst, label=label)

# Визуализация
plt.figure(figsize=(22, 14))

# Получаем позиции всех узлов
pos = nx.get_node_attributes(G, 'pos')

# Определяем цвета узлов
node_colors = []
for node in G.nodes():
    if 'Start' in node:
        node_colors.append('gold')
    elif 'Choose' in node:
        node_colors.append('lightblue')
    elif 'Forecast' in node:
        node_colors.append('lightgreen')
    elif 'S' in node:  # Конечные исходы
        node_colors.append('lightcoral')
    else:
        node_colors.append('lightgray')

# Рисуем узлы
nx.draw_networkx_nodes(G, pos, node_color=node_colors, 
                      node_size=3000, alpha=0.8, node_shape='s')

# Рисуем ребра
nx.draw_networkx_edges(G, pos, edge_color='gray', 
                      arrows=True, arrowsize=20, width=1.5)

# Добавляем метки узлов
labels = nx.get_node_attributes(G, 'label')
nx.draw_networkx_labels(G, pos, labels=labels, font_size=8, 
                       font_weight='bold', verticalalignment='center')

# Добавляем метки ребер
edge_labels = nx.get_edge_attributes(G, 'label')
nx.draw_networkx_edge_labels(G, pos, edge_labels=edge_labels, 
                            font_size=8, font_color='darkblue')

plt.title("Дерево решений: Выбор автопарка с возможностью заказа прогноза", 
          fontsize=16, fontweight='bold', pad=20)
plt.axis('off')

# Добавляем легенду
legend_elements = [
    plt.Rectangle((0, 0), 1, 1, fc='gold', alpha=0.8, edgecolor='black', label='Начало'),
    plt.Rectangle((0, 0), 1, 1, fc='lightblue', alpha=0.8, edgecolor='black', label='Решения'),
    plt.Rectangle((0, 0), 1, 1, fc='lightgreen', alpha=0.8, edgecolor='black', label='Случайные события'),
    plt.Rectangle((0, 0), 1, 1, fc='lightcoral', alpha=0.8, edgecolor='black', label='Конечные исходы'),
]
plt.legend(handles=legend_elements, loc='upper left', bbox_to_anchor=(0, 1), fontsize=10)

plt.tight_layout()

# Сохраняем и показываем
plt.savefig("decision_tree_autopark_simple.png", dpi=300, bbox_inches='tight')
print("Дерево решений сохранено в файл: decision_tree_autopark_simple.png")
plt.show()

# ========== КОНЕЦ КОДА ==========
