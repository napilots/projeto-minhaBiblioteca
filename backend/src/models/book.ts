import express from 'express'; 
import mongoose from 'mongoose';

// Criação do "molde" (Schema)
const bookSchema = new mongoose.Schema({
  nome: { type: String, required: true },
  autor: { type: String, required: true }
});

// Exporta o modelo para usarmos no servidor
export default mongoose.model('Book', bookSchema);