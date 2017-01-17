//
//  ConsentDocument.swift
//  consent_trial_1
//
//  Created by LIU ZEXI on 1/13/17.
//  Copyright © 2017 LIU ZEXI. All rights reserved.
//

import Foundation
import ResearchKit

public var ConsentDocument: ORKConsentDocument {
    let consentDocument = ORKConsentDocument()
    
    /*
     This is the title of the document, displayed both for review and in
     the generated PDF.
     */
    consentDocument.title = NSLocalizedString("Example Consent", comment: "")
    
    // This is the title of the signature page in the generated document.
    consentDocument.signaturePageTitle = NSLocalizedString("Consent", comment: "")
    
    /*
     This is the line shown on the signature page of the generated document,
     just above the signatures.
     */
    consentDocument.signaturePageContent = NSLocalizedString("I agree to participate in this research study.", comment: "")
    
    /*
     Add the participant signature, which will be filled in during the
     consent review process. This signature initially does not have a
     signature image or a participant name; these are collected during
     the consent review step.
     */
    let participantSignatureTitle = NSLocalizedString("Participant", comment: "")
    let participantSignature = ORKConsentSignature(forPersonWithTitle: participantSignatureTitle, dateFormatString: nil, identifier: "ParticipantSignature")
    
    consentDocument.addSignature(participantSignature)
    
    /*
     Add the investigator signature. This is pre-populated with the
     investigator's signature image and name, and the date of their
     signature. If you need to specify the date as now, you could generate
     a date string with code here.
     
     This signature is only used for the generated PDF.
     */
    /*
    let signatureImage = UIImage(named: "signature")!
    let investigatorSignatureTitle = NSLocalizedString("Investigator", comment: "")
    let investigatorSignatureGivenName = NSLocalizedString("Jonny", comment: "")
    let investigatorSignatureFamilyName = NSLocalizedString("Appleseed", comment: "")
    let investigatorSignatureDateString = "3/10/15"
    
    let investigatorSignature = ORKConsentSignature(forPersonWithTitle: investigatorSignatureTitle, dateFormatString: nil, identifier: "InvestigatorSignature", givenName: investigatorSignatureGivenName, familyName: investigatorSignatureFamilyName, signatureImage: signatureImage, dateString: investigatorSignatureDateString)
    
    consentDocument.addSignature(investigatorSignature)
    */
    /*
     This is the HTML content for the "Learn More" page for each consent
     section. In a real consent, this would be your content, and you would
     have different content for each section.
     
     If your content is just text, you can use the `content` property
     instead of the `htmlContent` property of `ORKConsentSection`.
     */
    let loremIpsumLongText = "haha"
    
    let htmlContentString = "<ul><li>Lorem</li><li>ipsum</li><li>dolor</li></ul><p>\(loremIpsumLongText)</p><p>\(loremIpsumLongText)</p>"
    
    /*
     These are all the consent section types that have pre-defined animations
     and images. We use them in this specific order, so we see the available
     animated transitions.
     */
    let consentSectionTypes: [ORKConsentSectionType] = [
        .overview,
        .dataGathering,
        .privacy,
        .dataUse,
        .timeCommitment,
        .studySurvey,
        .studyTasks,
        .withdrawing
    ]
    
    /*
     For each consent section type in `consentSectionTypes`, create an
     `ORKConsentSection` that represents it.
     In a real app, you would set specific content for each section.
     */
    var consentSections: [ORKConsentSection] = consentSectionTypes.map { contentSectionType in
        let consentSection = ORKConsentSection(type: contentSectionType)
        
        consentSection.summary = loremIpsumLongText
        
        if contentSectionType == .overview {
            consentSection.htmlContent = htmlContentString
        }
        else {
            consentSection.content = loremIpsumLongText
        }
        
        return consentSection
    }
    
    /*
     This is an example of a section that is only in the review document
     or only in the generated PDF, and is not displayed in `ORKVisualConsentStep`.
     */
    let consentSection = ORKConsentSection(type: .onlyInDocument)
    consentSection.summary = NSLocalizedString(".OnlyInDocument Scene Summary", comment: "")
    consentSection.title = NSLocalizedString(".OnlyInDocument Scene", comment: "")
    consentSection.content = loremIpsumLongText
    
    consentSections += [consentSection]
    
    // Set the sections on the document after they've been created.
    consentDocument.sections = consentSections
    
    return consentDocument
}



