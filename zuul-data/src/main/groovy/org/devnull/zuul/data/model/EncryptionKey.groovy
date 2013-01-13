package org.devnull.zuul.data.model

import groovy.transform.EqualsAndHashCode
import groovy.transform.ToString
import org.bouncycastle.openpgp.PGPPublicKey
import org.bouncycastle.openpgp.PGPPublicKeyRing
import org.bouncycastle.openpgp.PGPUtil
import org.codehaus.groovy.runtime.typehandling.GroovyCastException
import org.devnull.zuul.data.config.ZuulDataConstants
import org.hibernate.annotations.Cache
import org.hibernate.annotations.CacheConcurrencyStrategy

import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.Id
import javax.validation.constraints.Size

import static org.devnull.zuul.data.config.ZuulDataConstants.*

@Entity
@EqualsAndHashCode(includes = "name")
@ToString(includeNames = true, excludes = "password")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
class EncryptionKey implements Serializable {
    static final Map configurations = [
            "PBEWITHSHA256AND256BITAES-CBC-BC": [
                    description: "AES cipher with 256"
            ]
    ]
    static final long serialVersionUID = ZuulDataConstants.API_VERSION

    @Id
    @Size(min = 1, max = 32)
    @Column(length = 32)
    String name

    @Size(max = 64)
    @Column(length = 64)
    String description

    @Size(min = 8, max = 2000)
    @Column(nullable = false, length = 2000)
    String password

    Boolean defaultKey = false

    @Column(nullable = false, length = 255)
    String algorithm = KEY_ALGORITHM_AES

    Boolean compatibleWith(EncryptionKey otherKey) {
        return this.password == otherKey?.password &&
                this.algorithm == otherKey?.algorithm
    }

    Boolean isPgpKey() {
        return PGP_KEY_ALGORITHMS.find { it == algorithm } != null
    }

    Boolean isPbeKey() {
        return PBE_KEY_ALGORITHMS.find { it == algorithm} != null
    }

    def asType(Class type) {
        switch (type) {
            case EncryptionKey:
                return this
            case PGPPublicKey:
                def ring = new PGPPublicKeyRing(PGPUtil.getDecoderStream(new ByteArrayInputStream(password.bytes)))
                return ring.publicKeys?.find { it.encryptionKey } as PGPPublicKey
            default:
                throw new GroovyCastException("Hmm... ${this.class} cannot be converted to ${type}")
        }
    }
}
