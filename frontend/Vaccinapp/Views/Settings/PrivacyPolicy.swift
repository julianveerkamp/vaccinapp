//
//  PrivacyPolicy.swift
//  Vaccinapp
//
//  Created by Julian Veerkamp on 13.07.22.
//

import Foundation
import SwiftUI

struct PrivacyPolicy: View {
    static let text = """
This privacy notice explains how your data is processed and what data protection rights you have when using the Vaccinapp app to manage certain certificates – digital COVID Certificates proving coronavirus vaccinations.
Please also note the data protection information that you receive when your digital COVID Certificate is issued (e.g. at a vaccination/testing centre, doctor’s surgery or pharmacy).

This privacy notice covers the following topics:
- Who is the Vaccinapp app published by?
- What is the digital COVID Certificate?
- Is using the app voluntary?
- Why is your data processed?
- What data is processed?
- On what legal basis is your data processed?
- What permissions does the app require?
- When will your data be deleted?
- Who will receive your personal data?
- What rights do you have under data protection law?
- Data protection officer and contact

1. Who is the Vaccinapp app published by?

This app is published by Julian Veerkamp. The RKI is also responsible for ensuring that your personal data is processed in compliance with data protection regulations.


2. What is the digital COVID Certificate?

The digital COVID Certificate is proof that a person has
been vaccinated against COVID-19 (vaccination certificate),
tested negative for COVID-19 (test certificate) or
recovered from a COVID-19 infection (certificate of recovery).
Digital COVID Certificates have been valid within the entire European Union (EU) since 1 July 2021 as certification of COVID-19 vaccination and testing, and of recovery from a confirmed case of COVID-19. The official name is “EU Digital COVID Certificate” (certificate).
A certificate can be obtained on request from a competent entity (vaccination centres, testing points, doctor’s surgeries or pharmacies) after a vaccination, a test or after recovering from a confirmed case of COVID-19.
You can carry the certificate in paper form or in electronic form on your smartphone. Each certificate contains a QR code with an electronic signature from the RKI to protect against forgeries. If you would like to store a certificate on your smartphone, you can simply scan the QR code with the Vaccinapp app. The app then securely stores an electronic version of the certificate on your smartphone.

More information about how the certificate works is available on the following websites:
www.digitaler-impfnachweis-app.de/faq (provider: RKI)
https://ec.europa.eu/info/live-work-travel-eu/coronavirus-response/safe-covid-19-vaccines-europeans/eu-digital-covid-certificate_en (provider: EU Commission)

Please note that the QR codes on the certificates contain health data (data about coronavirus vaccinations, coronavirus test results or your recovery from a confirmed case of coronavirus). You should only show the certificates and QR codes if you want to provide appropriate proof. Do not provide QR codes to anyone if you do not want the data to be read. To prevent unwanted access to the certificates stored on your smartphone, you should set up a code lock on the device.

3. Is using the app voluntary?

Yes, using the app is voluntary. Each certificate can also be used in paper form as proof of vaccination. You will not suffer any disadvantages, because the paper version and the electronic version of the certificate are equivalent. You can decide at any time whether you want to scan the QR code and store the certificate in the app. You can also delete the certificate from the app at any time.

4. Why is your data processed?

a. Certificate creation

The RKI briefly processes the necessary personal data of certificate holders to technically create and sign the requested certificate (Sect. 22a(5)–(7) of the Infection Protection Act, IfSG). The personal data is deleted at the RKI immediately once the technical creation of the certificate is complete. There is no centrally administered registry of vaccinations or certificates.

b. Using certificates as proof

You can use the Vaccinapp app to scan your own printed certificates and those of family members and store them in encrypted form on your smartphone.
In order to prove to third parties – in the situations where this is required by law – that you have been vaccinated, have tested negative, or have recovered from COVID-19, you can show the relevant certificate to the person performing the check. If the person performing the check uses a special verification app (such as the RKI’s VaccinappCheck app), it is sufficient to show the QR code of the certificate and have it scanned. The QR code is the certificate in digital form and contains only the information necessary for the specific type of certificate (see Section 5).
The verification app allows for example authorities, travel companies and other service providers in the EU to scan the QR code of the certificate presented to them, in order to check its validity. During the verification, the data contained in the certificate is read. For the certificate to be valid, it must meet the following technical and formal criteria:
The certificate contains a valid electronic signature.
The certificate has not been revoked.
The technical expiration date of the certificate has not yet been reached.
The certificate meets the formal criteria applicable at the place where it is verified (e.g. regional entry rules).
The verification app will show whether the certificate provided is valid and, if applicable, whether another certificate needs to be scanned (“2G+”). If the certificate is valid, the name and date of birth of the certificate holder will also be disclosed, as will whether or not it is a test certificate. In the case of test certificates, the time of sampling will also be displayed.
The name and date of birth of the certificate holder are displayed so that the person performing the check can compare this information with an ID document (e.g. passport or ID card). A notification of whether the certificate is a test certificate, and the time of sampling, are necessary to enable the person performing the check to assess whether the test result on which the certificate is based is still valid.

c. Electronic signature of certificates, revocation and entry rules

To protect against forged certificates, it is necessary to verify the authenticity of the stored certificates. The electronic signature contained in a certificate’s QR code is used for this purpose. The electronic signature is generated by the RKI when creating the certificate, on the basis of the data contained in the certificate (see Section 5). The signature is a special type of encryption that allows the RKI to confirm that the certificate is an official digital document created by the RKI.
The RKI also provides the corresponding public keys from the RKI. These public keys can be used to check whether a certificate’s electronic signature actually originates from the RKI and whether the certificate has been manipulated since being signed electronically.
To protect the health of certificate holders and the public, certain certificates may be revoked in special cases. This may be necessary, for example, if a competent entity (e.g. pharmacy, vaccination centre or doctor’s surgery) has issued an incorrect certificate. The competent hazard prevention authorities will decide on whether to revoke a certificate, and the revocation is then technically implemented by the RKI (Sect. 22a(8) IfSG). Revocation will result in the certificate becoming invalid and no longer being accepted when verified. It does not matter whether the certificate is presented in electronic form on a smartphone or on paper during the verification. If you have stored a revoked certificate in the app, it will show as “invalid”.
To be able to determine the validity of the electronic signature or whether stored certificates have been revoked, the app regularly downloads the RKI’s current public keys and revocation lists in the background and stores them locally on your smartphone. The public keys do not contain any personal data. The revocation lists only contain a revocation identifier for a revoked certificate in the form of special one-way encryption (what’s known as a hash value). The revocation identifier cannot be used to infer the certificate data or other information about a particular person. The RKI receives the revocation identifier of a certificate to be revoked from the competent hazard prevention authority, which has read this identifier from the incorrect certificate. If, in exceptional cases, it is necessary to revoke all certificates issued by the same competent entity (e.g. a specific pharmacy), only a small subsection from the unique certificate identifier of the issued certificates will be transferred to the revocation list instead of the individual revocation identifiers. This subsection is identical for all certificates issued by the same competent entity. The Vaccinapp app then compares this with the unique certificate identifier of the certificates stored on the smartphone. If there is a match between the identifier of the stored certificates and the certificates on the revocation list, the certificate in question will show as “invalid” in the Vaccinapp app. Both the verification of the electronic signature and the comparison with the revocation lists take place exclusively locally in the app and no data about this process is passed on to the RKI or other agencies.
You can use the “Check validity” feature to check for yourself whether the certificates stored in the app meet the official formal requirements of a particular EU country. EU countries may adopt their own rules for the validity of certificates. For example, test certificates may be valid for a longer period in some EU countries than in others. The EU countries exchange these rules via a common exchange server. Before starting a trip, you can therefore use the app to check whether your certificates are valid in the destination country.
If you want to check whether a certificate is valid, your app downloads the current rules of all Member States from the app’s server system. The app then uses the data contained in a certificate to check whether that certificate complies with the rules before showing you the corresponding result. The verification takes place exclusively offline in the app and no data is passed on here to the RKI or other recipients (other health authorities in Germany or other countries and other third parties).
Please note that entry rules are subject to change and additional rules may apply both in the destination country and when you return. Guidance on entry requirements can also be found on this EU website: https://reopen.europa.eu/en

5. What data is processed?

a. Certificate data

The certificates contain health data and are stored in a secure area on your smartphone. The certificates contain the following data:
Data about the certificate holder (last name, first name, date of birth),
type of certificate (vaccination certificate, test certificate, certificate of recovery),
the necessary information about the vaccination, the test or the recovery
a unique certificate identifier,
the RKI’s electronic signature and
a QR code containing the aforementioned data in encoded form.
You can find out what specific information is stored in a certificate from the information provided on the certificate (in German and English). No information other than that indicated on the certificate is stored.
This data will be stored in the app as soon as you scan the QR code on the printed certificate. This data was collected previously by the entity that issued the certificate, and transmitted to the RKI so that the certificate could be signed.
When a certificate is updated, the hash values of the signature of the updated and new certificates are temporarily stored on the app’s server system by means of special one-way encryption (see Section 4 e.).

b. Access data

In order to download the RKI’s public key for authenticating the electronic signature, the revocation lists and current rules of the Member States on the validity of certificates, and the rules on booster vaccination recommendations, a connection needs to be established to an RKI server. The server has to process technical access data for this purpose. This data includes the following:
IP address
Date and time of retrieval
Transmitted data volume (or packet length)
Notification of whether the data exchange was a success.
This access data is processed to enable and secure the connection and data exchange between the app and the server. You will not be identified personally as a user of the app and no user profile will be created. Your IP address will not be stored beyond the end of the individual usage procedure.

6. On what legal basis is your data processed?

The RKI processes the certificate data mentioned above in Section 5 a. for the purpose of technically creating and signing the requested certificate. The legal basis for the processing in each case is Art. 6(1) Sentence 1(c), Art. 9(2)(g) of the General Data Protection Regulation (GDPR) in conjunction with
Sect. 22a(5) IfSG (vaccination certificate),
Sect. 22a(6) IfSG (certificate of recovery) or
Sect. 22a(7) IfSG (test certificate).
According to Sect. 22a(5)–(7) IfSG, the RKI is obliged to technically create and sign the requested certificate, provided that the vaccinated, recovered or tested person requests the issuance of such a certificate.
Since 1 July 2021, there has also been a basis under European law for this processing. In this respect, the legal basis is Art. 6(1) Sentence 1(c), Art. 9(2)(g) GDPR in conjunction with Art. 10(2) of Regulation (EU) 2021/953 of the European Parliament and of the Council of 14 June 2021 on a framework for the issuance, verification and acceptance of interoperable COVID-19 vaccination, test and recovery certificates (EU Digital COVID Certificate) to facilitate free movement during the COVID-19 pandemic).
The processing of data in connection with the feature for verifying COVID certificates for ticket bookings is based on your consent. The legal basis is Art. 6 (1) lit. a, Art. 9 (2) lit. a DSGVO.
The legal basis for the processing of the access data mentioned above in Section 5 b. is Sect. 3 of the German Federal Data Protection Act (BDSG) and Art. 6(1) Sentence 1(e) GDPR.
When updating certificates (see Section 4 e.), the data of the certificates that have been submitted for updating is processed on the basis of your consent. The legal basis is Art. 6(1) Sentence 1(a), Art. 9(2)(a) GDPR. Temporary storage of the hash value of the signature of the updated certificate is carried out on the basis of Sect. 22(1)(c) BDSG and Art. 9(2)(i) GDPR.
The legal basis for data processing in connection with certificate revocations is Sect. 22a(8) IfSG.

7. What permissions does the app require?

The Vaccinapp app requires access to your smartphone camera when you scan the QR code to add a certificate in the app. The app also requires an internet connection in order to download up-to-date information from the RKI’s server system (e.g. the latest key information, revocation lists). For information about other permissions the app may request, please refer to the FAQ section in the app.

8. When will your data be deleted?

The certificates will only be stored in the app on your smartphone. The certificates are not automatically deleted in your app. If you wish to delete a certificate, you can remove a certificate from the app yourself at any time or delete the app. To add the certificate again later, you will need to rescan the QR code of the printed certificate.
The booking information required for the verification of certificates for ticket bookings will be deleted after the verification.
When a certificate has been created, the data is permanently deleted at the RKI immediately after the signed certificate has been provided to the issuing entity.
In the case of updating a certificate, the data will be deleted again at the RKI after the updated certificate has been sent to your app. Only the hash values of the updated and new certificates will be stored on the RKI’s server system for 365 days
The revocation identifiers of revoked certificates on the revocation lists are stored on the app’s server system until the technical expiration date of the respective certificates.

9. Who will receive your personal data?

The RKI has commissioned the company KDO Service GmbH (KDO) to operate and maintain the server system. KDO processes the personal data on behalf and at the instruction of the RKI (meaning it is what’s known as a processor under data protection law). Contractual safeguards are in place to ensure that the data protection requirements are met.
If, in the situations where it is required by law, you present a certificate to other persons or entities (for example, European border authorities or service providers), they will become aware of all the data contained in the certificate.
You can prevent this by showing the QR code in the app, so that it can be scanned using a verification app. Then, the data contained in the QR code will be read. Here the verification app will only show whether the certificate shown is valid, an explanation of the result and, if applicable, whether another certificate needs to be scanned (“2G+”). In the case of a valid certificate, the name and date of birth of the certificate holder are displayed additionally in the verification app, so that the person performing the check can compare this information with an ID document (e.g. passport or ID card).
The verification app will only process the displayed data for a short time. Once the verification is complete, the displayed data is discarded, meaning the data that has been read is not permanently stored.

10. What rights do you have under data protection law?

If the RKI processes your personal data, you have the following data protection rights:
The rights under Art. 15, 16, 17, 18 and 21 GDPR,
the right to contact the official RKI Data Protection Officer and raise your concerns (Art. 38(4) GDPR) and
the right to lodge a complaint with a data protection supervisory authority. To do so, you can for example contact your local supervisory authority or the authority responsible for the RKI. The supervisory authority responsible for the RKI is the Federal Commissioner for Data Protection and Freedom of Information, Graurheindorfer Straße 153, 53117 Bonn.
Please note that the RKI can only fulfil the rights mentioned above if data to which the asserted claims relate is processed on an ongoing basis. This would only be possible if personal data were stored after being transmitted to the RKI server. This is not generally necessary for the purposes of the app. For this reason, the aforementioned data protection rights under Art. 15, 16, 17, 18 and 21 GDPR are largely redundant. If the hash value of the signature is temporarily stored when a certificate is updated, this does not enable the RKI to determine the identity of certificate holders (see Section 4 e.).

11. Data protection officer and contact

If you have any questions or concerns regarding data protection in connection with the Vaccinapp app, you are welcome to send them by emailing datenschutz@veerkamp.me.
"""
    
    var body: some View {
        ScrollView {
            Text(PrivacyPolicy.text).padding()
        }
        .navigationTitle("Privacy Policy")
        .navigationBarTitleDisplayMode(.inline)
    }
}
