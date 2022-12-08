//
//  AddNoteDelegate.swift
//  adlazareva_HW5
//
//  Created by Настя Лазарева on 07.12.2022.
//

import Foundation

protocol AddNoteDelegate : AnyObject{
    func newNoteAdded(note : ShortNote)
}
