extends RefCounted
class_name TrainingScore

var score := 0
var feedback: Array[String] = []

func award_position(correct: bool) -> void:
    if correct:
        score += 50
        feedback.append("Position correcte : +50 XP")
    else:
        feedback.append("Revoir le positionnement avant de poursuivre.")

func award_sequence(correct: bool) -> void:
    if correct:
        score += 100
        feedback.append("Enchaînement validé : +100 XP")
    else:
        feedback.append("Séquence à revoir avec la référence pédagogique.")

func award_clean_finish(second_cuts: int, marks: int) -> void:
    if second_cuts == 0 and marks == 0:
        score += 150
        feedback.append("Finition propre : +150 XP")
    else:
        score -= second_cuts * 15 + marks * 25
        feedback.append("Pénalités pédagogiques appliquées.")
